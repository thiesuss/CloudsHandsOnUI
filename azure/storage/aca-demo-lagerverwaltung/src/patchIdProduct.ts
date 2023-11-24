import { validationResult } from "express-validator";
import { products } from ".";
import { Request, Response } from "express";
import redis from './redis';
//redis check ?


export default async function (req: Request, res: Response) { 
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ validationErrors: errors.array() });
    }

    try {
            const exists = await redis.hExists('inventory:items:' + req.params.id, 'stock');
            if (exists) {
                await redis.hSet('inventory:items:'+ req.params.id, {
                    stock: req.body.stock
                });
                const updproduct = await redis.hGetAll('inventory:items:'+ req.params.id);
                res.json(updproduct);
            } else {
                res.status(404).json({ error:'Product does not exist!'});
            }
        } catch (error) {
            res.status(500).json({ error:'Fehler beim Update'});
    }
    



}

