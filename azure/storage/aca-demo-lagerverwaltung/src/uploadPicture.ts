import { NextFunction, Request, Response } from "express";
import fileUpload, { UploadedFile } from 'express-fileupload';
import { blobContainerClient } from ".";
import { v4 as uuid } from "uuid";
import redis from './redis';
import { BlockBlobClient } from "@azure/storage-blob";

export default async function (req: Request, res: Response, next: NextFunction) {
    const productID: string = req.params.id;
    const productKey = 'inventory:items:' + productID;
    try {
        
        const productImage = await redis.hGet(productKey, 'image');
        if (productImage) {
            // delete image in cache and blob
            const imageKey = 'inventory:image:' + productImage;
            const imageFileName = await redis.hGet(imageKey, 'filename');
            if (imageFileName) {
                const blobClient: BlockBlobClient = blobContainerClient.getBlockBlobClient(imageFileName);
                await blobClient.deleteIfExists();
            }

            await redis.del(imageKey);
        }

        if (!req.files || !req.files.image) {
            res.status(400);
            return res.json({ error: 'No file uploaded!' });
        }
        const file: UploadedFile =
            Array.isArray(req.files.image) ? req.files.image[0] : req.files.image;
        const fileType: string | undefined = file.mimetype.split('/').pop();

        if (!fileType) {
            res.status(400);
            return res.json({ error: 'Could not get file type!' });
        }

        const id: string = uuid();
        const fileName: string = `${id}.${fileType}`;

        const blobClient: BlockBlobClient = blobContainerClient.getBlockBlobClient(fileName);

        await blobClient.uploadData(file.data);
        await blobClient.setHTTPHeaders({
            blobContentType: file.mimetype,
            blobContentEncoding: file.encoding
        });

        const transaction = redis.multi();
        transaction.hSet(productKey, {
            image: id
        });

        transaction.hSet('inventory:image:' + id, {
            filename: fileName
        });
        
        await transaction.exec();
        next();
    } catch (error) {
        next(error);
    }
}