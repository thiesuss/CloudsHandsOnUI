export interface Product {
    id: number;
    name: number;
    price: string;
    stock: number;
}
import {ServiceBusMessage} from "@azure/service-bus";
export interface ChangeStockMessage extends ServiceBusMessage {
    body: {
        productId: number,
        amount: number,
        type: 'incr' | 'decr'
    }
}