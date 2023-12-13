import { Request, Response, NextFunction } from 'express';
import ApiError from '../ApiError';
import { Order, OrderEntry, ChangeStockMessage, Product } from '../types';
import ordersDB from '../ordersDB';
import { inventoryService } from '..';
import { stockSender } from '../sbClient';

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

        const orderEntry: OrderEntry = ordersDB.addOrder(order);

        const messages: ChangeStockMessage[] = [];
        for (const position of order.items) {
            let product: Product | undefined = products.find(p => p.id === position.id);
            if (!product) continue;

            //await inventoryService.updateProductStock(product.id, product.stock - position.quantity);
            messages.push({
                body: {
                    type: 'decr',
                    amount: position.quantity,
                    productId: product.id
                }
            })
        }

        let batch = await stockSender.createMessageBatch();
        for (const msg of messages) {
            if (!batch.tryAddMessage(msg)) {
                await stockSender.sendMessages(batch);
                batch = await stockSender.createMessageBatch();
                if (!batch.tryAddMessage(msg)) {
                    throw new Error('Can\'t add message to batch.');
                }
            }
        }
        await stockSender.sendMessages(batch);

        res.status(200);
        return res.json(orderEntry);
    } catch (error) {
        next(error);
    }
}