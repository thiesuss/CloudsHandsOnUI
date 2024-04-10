import { Request, Response, NextFunction } from 'express';
import { OrderEntry, OrderPosition, RedisOrder } from '../types';
import redis from '../redis';
export default async function (req: Request, res: Response, next: NextFunction) {
    try {
        let orders: OrderEntry[] = [];
        for await (const key of redis.scanIterator({ MATCH: 'orders:order:*'})) {
            console.log(key);
            if (!new RegExp(/orders:order:[0-9(a-f|A-F)]{8}-[0-9(a-f|A-F)]{4}-4[0-9(a-f|A-F)]{3}-[89ab][0-9(a-f|A-F)]{3}-[0-9(a-f|A-F)]{12}$/gmi).test(key)) continue;
            console.log('Durch: ' + key);
            const orderCache = await redis.hGetAll(key);
            const order: RedisOrder = { customer: orderCache.customer };

            const positionIDs = await redis.sMembers(`${key}:positions`);
            const positions: OrderPosition[] = [];
            for (const positionID of positionIDs) {
                const position = await redis.hGetAll(`${key}:positions:${positionID}`);
                positions.push({ id: position.id, quantity: parseInt(position.quantity) });
            }

            orders.push({ id: key.split(':').pop() || "", customer: order.customer, items: positions });       
        }

        res.status(200);
        return res.json(orders);
    } catch (error) {
        next(error);
    }
}