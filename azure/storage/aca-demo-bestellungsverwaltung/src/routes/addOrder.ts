import { Request, Response, NextFunction } from 'express';
import { v4 as uuid } from 'uuid';
import ApiError from '../ApiError';
import { Order, OrderEntry, OrderPosition, Product } from '../types';
//import ordersDB from '../ordersDB';
import redis from '../redis';
import { inventoryService } from '..';

export default async function (req: Request<{}, {}, Order>, res: Response, next: NextFunction) {
    try {
        const order: Order = req.body;

        let products: Product[] = [];
        for (const position of order.items) {
            let product: Product;
            try {
                product = await inventoryService.getProductById(position.id);
            } catch (err) {
                if (err instanceof ApiError && err.httpCode === 404) {
                    throw new ApiError(`Product with ID ${position.id} does not exist`, 400);
                }
                throw err;
            }

            if (product.stock < position.quantity) {
                throw new ApiError(`Product "${product.name}" is not in stock in that quantity!`, 400);
            }

            products.push(product);
        }

        //const orderEntry: OrderEntry = ordersDB.addOrder(order);
        const orderEntry: OrderEntry = await writeOrderToCache(order);

        for (const position of order.items) {
            let product: Product | undefined = products.find(p => p.id === position.id);
            if (!product) continue;

            await inventoryService.updateProductStock(product.id, product.stock - position.quantity);
        }

        res.status(200);
        return res.json(orderEntry);
    } catch (error) {
        next(error);
    }
}

async function writeOrderToCache(order: Order): Promise<OrderEntry> {
    const orderId: string = uuid();

    const transaction = redis.multi();

    transaction.hSet('orders:order:' + orderId, {
        customer: order.customer
    });

    const positions = new Set<string>();

    for (const position of order.items) {
        const id: string = uuid();
        transaction.hSet(`orders:order:${orderId}:positions:${id}`, { ...position });
        positions.add(id);
    }

    transaction.sAdd(`orders:order:${orderId}:positions`, [ ...positions ]);
    await transaction.exec();

    return { id: orderId, ...order };
}