import { validationResult } from "express-validator";
import { products } from ".";
import { Request, Response } from "express";
import redis from './redis';
//redis check?



export default async function (req: Request, res: Response) {

    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ validationErrors: errors.array() });
    }

    try {
        const result = await redis.del('inventory:items:'+ req.params.id);
        if (result>0) {


            res.status(200).json({msg: 'Deleted succesfully'});

        } else {
            res.status(404).json({ error:'Product does not exist!'});
        }
    } catch (error) {
        res.status(500).json({ error:'Fehler beim Update'});
    }
    
}