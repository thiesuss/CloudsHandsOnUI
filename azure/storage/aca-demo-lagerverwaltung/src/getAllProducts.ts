import { products } from ".";
import { validationResult } from "express-validator";
import { Request, Response } from "express";
import redis from './redis';
import { promisify } from "node:util";
import { Product } from './products';





export default async function (req: Request, res: Response) {


    
    let objects: any[] = [];
    for await (const key of redis.scanIterator({ MATCH: 'inventory:items:*'})) { //Iterator über alle keys
        
        const object = await redis.hGetAll(key);

         objects.push({ id:key.split(':').pop(), ...object});        
    }
    res.json(objects);
    

}