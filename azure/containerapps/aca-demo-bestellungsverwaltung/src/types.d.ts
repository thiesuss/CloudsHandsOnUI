export interface OrderPosition {
    id: number,
    quantity: number
}

export interface Order {
    customer: string,
    items: OrderPosition[]
}

export interface OrderEntry extends Order {
    id: number
}

export interface Product {
    id: number,
    name: string,
    price: number,
    stock: number
}