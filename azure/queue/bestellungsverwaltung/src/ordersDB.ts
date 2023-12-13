import { Order, OrderEntry } from './types';

export class Orders {
    private counter: number = 1;
    private orders: OrderEntry[] = [];

    getOrders(): OrderEntry[] {
        return this.orders;
    }

    addOrder(order: Order): OrderEntry {
        const orderEntry: OrderEntry = { id: this.counter++, ...order };
        this.orders.push(orderEntry);
        return orderEntry;
    }

    findById(id: number): OrderEntry | null {
        return this.orders.find(order => order.id === id) || null;
    }
}

export default new Orders();