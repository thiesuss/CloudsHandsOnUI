import { Request, Response, NextFunction } from 'express';
import ApiError from '../ApiError';
import { OrderEntry } from '../types';
import ordersDB from '../ordersDB';
export default function (req: Request, res: Response, next: NextFunction) {
    try {
        const id: number = parseInt(req.params.id);

        const order = ordersDB.findById(id);
        if (order === null) {
            throw new ApiError("Order does not exist", 404);
        }

        res.status(200);
        return res.json(order);
    } catch (error) {
        next(error);
    }
}