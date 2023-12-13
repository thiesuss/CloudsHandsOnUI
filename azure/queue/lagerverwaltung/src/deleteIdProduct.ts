import { validationResult } from "express-validator";
import { Request, Response } from "express";
import {products} from "./index";


export default async function (req: Request, res: Response) {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ validationErrors: errors.array() });
    }

    const index = products.findIndex((p) => p.id === parseInt(req.params.id));

    if(index === -1) {
        
        res.status(404).json({ error:'Product does not exist!'});
    } else {
        products.splice(index, 1);
        res.status(204).send();
    }
    
}