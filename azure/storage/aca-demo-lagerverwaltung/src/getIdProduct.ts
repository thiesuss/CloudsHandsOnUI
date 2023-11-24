import { validationResult } from "express-validator";
import { products } from ".";
import { Request, Response } from "express";
import redis from './redis';
//redis check?


export default async function (req: Request, res: Response)  {
    const errors = validationResult(req); // auf gültige id prüfen
    if (!errors.isEmpty()) { //Alle Fehlermelden
        return res.status(400).json({ validationErrors: errors.array() });
    }

    //const product = products.find((p) => p.id === req.params.id);
    const product = await redis.hGetAll('inventory:items:'+ req.params.id);
    if(!product) {
        
        res.status(404).json({ error:'Product does not exist!'});
    } else {
        res.json({ id: req.params.id, ...product}); //einfach die id vorgesetzt ... heißt pack alles aus product ein
    }
}