import { validationResult } from "express-validator";
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
        return res.status(404).json({ error:'Product does not exist!'});
    }

    let image = null;
    if (product.image) {
        image = await redis.hGetAll('inventory:image:' + product.image);
    }

    return res.json({ id: req.params.id, ...product, image })
}