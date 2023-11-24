export interface OrderPosition {
    id: string,
    quantity: number
}

export interface Order {
    customer: string,
    items: OrderPosition[]
}

export interface OrderEntry extends Order {
    id: string
}

export interface Product {
    id: string,
    name: string,
    price: number,
    stock: number
}