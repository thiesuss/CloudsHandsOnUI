import { Request, Response } from "express";
import {products} from "./index";






export default async function (req: Request, res: Response) {   
    res.json(products);
}