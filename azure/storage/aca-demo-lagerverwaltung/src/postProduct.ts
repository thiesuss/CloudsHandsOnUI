import { validationResult } from "express-validator";
import { Request, Response } from "express";
import { Product } from "./products";
import redis from './redis';

import { v4 as uuid } from 'uuid';
//const id:string = uuid(); //id rückgabe

//redis check?

export default async function (req: Request, res: Response) {     
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ validationErrors: errors.array() });
    }

    //todo id numbers zum String machen vakidate und alles ändern
    const key = uuid();
    await redis.hSet(
        'inventory:items:'+key,
        {
            name: req.body.name,
            stock: req.body.stock,
            price: req.body.price,
        }
    );
    
    const product: Product = { //
        id: key,
        name: req.body.name,
        price: req.body.price,
        stock: req.body.stock,
    };


    res.status(201).json(product);
}

//Key in WOrd ist quasi der Name in Redis
// IN redis sind alles Key/name value Paare

//Git nicht vergessen links den Branch oben mit den einzelnen Commits und unten synchronize
//https://redis.io/docs/data-types/