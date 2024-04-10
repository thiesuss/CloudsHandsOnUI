import { Request, Response, NextFunction } from "express";
import { validationResult } from "express-validator";

export default function (req: Request, res: Response, next: NextFunction) {
    const result = validationResult(req);

    if (!result.isEmpty()) {
        res.status(400);
        return res.json({
            validationErrors: result.array()
        });
    }
    
    next();
}