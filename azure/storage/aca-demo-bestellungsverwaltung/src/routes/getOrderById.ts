import { Request, Response, NextFunction } from 'express';
import ApiError from '../ApiError';
import { OrderEntry, OrderPosition } from '../types';
import redis from '../redis';
export default async function (req: Request, res: Response, next: NextFunction) {
    try {
        const id: string = req.params.id;

        let orderEntry: OrderEntry;

        const order = await redis.hGetAll('orders:order:' + id);
        if (order.customer) {
            const positionIDs = await redis.sMembers(`orders:order:${id}:positions`);
            const positions: OrderPosition[] = [];
            for (const positionID of positionIDs) {
                const position = await redis.hGetAll(`orders:order:${id}:positions:${positionID}`);
                positions.push({ id: position.id, quantity: parseInt(position.quantity) });
            }
            orderEntry = { id, customer: order.customer, items: positions };
        } else {
            throw new ApiError('Nicht im cache', 404);
        }

        res.status(200);
        return res.json(orderEntry);
    } catch (error) {
        next(error);
    }
}