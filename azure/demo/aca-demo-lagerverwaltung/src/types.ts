export interface Product {
    id: string;
    name: number;
    price: string;
    stock: number;
}
import {ServiceBusMessage} from "@azure/service-bus";
export interface ChangeStockMessage extends ServiceBusMessage {
    body: {
        productId: string,
        amount: number,
        type: 'incr' | 'decr'
    }
}