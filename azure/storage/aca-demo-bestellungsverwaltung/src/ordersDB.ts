import { Order, OrderEntry } from './types';
import { v4 as uuid } from 'uuid';

export class Orders {
    private orders: OrderEntry[] = [];

    getOrders(): OrderEntry[] {
        return this.orders;
    }

    addOrder(order: Order): OrderEntry {
        const orderEntry: OrderEntry = { id: uuid(), ...order };
        this.orders.push(orderEntry);
        return orderEntry;
    }

    findById(id: string): OrderEntry | null {
        return this.orders.find(order => order.id === id) || null;
    }
}

export default new Orders();