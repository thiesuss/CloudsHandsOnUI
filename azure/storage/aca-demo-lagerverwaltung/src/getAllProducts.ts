import { Request, Response } from "express";
import redis from './redis';

export default async function (req: Request, res: Response) {    
    let objects: any[] = [];
    for await (const key of redis.scanIterator({ MATCH: 'inventory:items:*'})) { //Iterator über alle keys
        const object = await redis.hGetAll(key);

        let image = null;
        if (object.image) {
            image = await redis.hGetAll('inventory:image:' + object.image);
        }        

         objects.push({ id:key.split(':').pop(), ...object, image });        
    }

    return res.json(objects);
}