import dotenv from 'dotenv';
import express, { NextFunction, Request, Response } from 'express';
import { Product } from './products';
import { productNamePriceValidateRules, productStockValidate, idParamValidate } from './validate'; 
import { body, validationResult } from 'express-validator'; 
import cors from 'cors';
import morgan from 'morgan';
import { BlobServiceClient, BlockBlobClient, BlockBlobParallelUploadOptions, ContainerClient } from '@azure/storage-blob';
import fileUpload from 'express-fileupload';
//Importiert etwas womit alle übergebenen validierungsregeln in 
//einem Methodenaufruf abgearbeitet werden validationResult(req);
//npm run dev hoppsscotch http//localhost:8080/api/products/



import redis from './redis';//falls woanders redis nutzen nicht noch mal connect aber import redis
//https://redis.io/docs/data-types/ // hashes Node.js

dotenv.config();
//app ist der Server, Router ist einfacherer Server. app kann mehrere Router besitzen
const app = express();
app.use(morgan('combined')); //Logging aktivieren
if(process.env.CORS === 'true'){
    app.use(cors()); 
}
app.use(express.json()); // Add this line to enable JSON parsing in the request body

redis.connect()
    .then(() => {
        console.log('Connected to Redis on host ', process.env.REDIS_HOST)
    });//Connection aufbau zum Redis Cache

if (!process.env.BLOB_ACCOUNT_URL) {
    throw new Error('No Blob Account URL given');
}

if (!process.env.BLOB_CONTAINER_NAME) {
    throw new Error('No Blob Container name given');
}

if (!process.env.BLOB_SAS_UPLOAD_TOKEN) {
    throw new Error('No SAS token given');
}

export const blobServiceClient =
    new BlobServiceClient(`${process.env.BLOB_ACCOUNT_URL}?${process.env.BLOB_SAS_UPLOAD_TOKEN}`);
export const blobContainerClient =
    blobServiceClient.getContainerClient(process.env.BLOB_CONTAINER_NAME);

import postProduct from './postProduct';
//Ein neues Produkt erstellen
app.post('/api/products', productNamePriceValidateRules, productStockValidate, postProduct);

import getAllProducts from './getAllProducts'; //auslagern der Function
//Liste an Produkten antworten
app.get('/api/products', getAllProducts); //function als default daher einfach der Name der Datei

import getIdProduct from './getIdProduct';
//Ein Produkt antworten oder keines -> Error
app.get('/api/products/:id', idParamValidate, getIdProduct);

import patchIdProduct from './patchIdProduct';
//vorhandenes Product ändern
app.patch('/api/products/:id', idParamValidate, productStockValidate, patchIdProduct);

import deleteIdProduct from './deleteIdProduct';
//product loeschen
app.delete('/api/products/:id', idParamValidate,deleteIdProduct);

import uploadPicture from './uploadPicture';
app.put('/api/products/:id/picture', idParamValidate, fileUpload(), uploadPicture, getIdProduct);




app.listen(Number(process.env.PORT), () => {
    console.log("Server running on port " + process.env.PORT);
});

// Add this error handling middleware
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
    console.error(err.stack);
    res.status(500).send('Internal Server error');
  });

// const task = tasks.find((t) => t.id === parseInt(req.params.id));

// tasks ist eine selbst angelegte Liste in der wir den Wert speichern in welchem t.id 
//der id entspricht und req.params.id die als Parameter übergeben id ausliest 
//(parseint moeglich hier nicht geprüft) falls id body dann .body.  statt .param. 