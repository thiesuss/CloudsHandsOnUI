import { Request, Response, NextFunction } from 'express';
import { OrderEntry } from '../types';
import ordersDB from '../ordersDB';
export default function (req: Request, res: Response, next: NextFunction) {
    try {
        const orders: OrderEntry[] = ordersDB.getOrders();

        res.status(200);
        return res.json(orders);
    } catch (error) {
        next(error);
    }
}