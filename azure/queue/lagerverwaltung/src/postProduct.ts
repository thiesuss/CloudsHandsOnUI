import { validationResult } from "express-validator";
import { Request, Response } from "express";
import { Product } from "./types";

import {products} from "./index";



export default async function (req: Request, res: Response) {     
    //Ein neues Produkt erstellen

    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ validationErrors: errors.array() });
    }
    
    const product: Product = {
        id: products.length +1,
        name: req.body.name,
        price: req.body.price,
        stock: req.body.stock,
    };

    products.push(product);
    res.status(201).json(product);

}

