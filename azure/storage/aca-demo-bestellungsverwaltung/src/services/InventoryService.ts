import ApiError from "../ApiError";
import { Product } from "../types";
export default class InventoryService {
    apiUrl: string = '';
    
    constructor(apiUrl: string) {
        if (apiUrl.endsWith('/')) {
            apiUrl = apiUrl.substring(0, apiUrl.length - 1);
        }
        this.apiUrl = apiUrl;
    }

    async getAllProducts(): Promise<Product[]> {
        const res = await fetch(this.apiUrl + '/products');
        const products = await res.json() as Product[];
        return products;
    }

    async getProductById(productId: string): Promise<Product> {
        const res = await fetch(this.apiUrl + '/products/' + productId);

        if (!res.ok && res.status === 404) {
            const msg = (await res.json()).error ?? 'Resource not found';
            throw new ApiError(msg, 404);
        } else if (!res.ok) {
            throw new Error('Error accessing Inventory API');
        }

        const product = await res.json() as Product;
        return product;
    }

    async updateProductStock(productId: string, stock: number): Promise<Product> {
        const res = await fetch(this.apiUrl + '/products/' + productId, {
            method: 'PATCH',
            headers: {
                'content-type': 'application/json'
            },
            body: JSON.stringify({ stock })
        });

        if (!res.ok && res.status === 404) {
            const msg = (await res.json()).error ?? 'Resource not found';
            throw new ApiError(msg, 404);
        } else if (!res.ok) {
            throw new Error('Error accessing Inventory API');
        }

        const product = await res.json() as Product;
        return product;
    }
}