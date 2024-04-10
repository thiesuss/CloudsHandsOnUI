import { validationResult } from "express-validator";
import { Request, Response } from "express";


import {products} from "./index";



export default async function (req: Request, res: Response)  {
    const errors = validationResult(req); // auf gültige id prüfen
    if (!errors.isEmpty()) { //Alle Fehlermelden
        return res.status(400).json({ validationErrors: errors.array() });
    }

    const product = products.find((p) => p.id === parseInt(req.params.id));

    if(!product) {
        
        res.status(404).json({ error:'Product does not exist!'});
    } else {
        res.json(product);
    }
}

