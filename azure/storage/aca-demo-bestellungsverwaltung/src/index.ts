import dotenv from 'dotenv';
import express, { Request, Response } from 'express';
import cors from 'cors';
import morgan from 'morgan';
import defaultErrorHandler from './middleware/defaultErrorHandler';

import router from './router';

import InventoryService from './services/InventoryService';
import redis from './redis';

dotenv.config();

if (!process.env.INVENTORY_API_URL) {
    throw new Error('Environment variable INVENTORY_API_URL must be defined!');
}

export const inventoryService = new InventoryService(process.env.INVENTORY_API_URL);

redis.connect()
    .then(() => {
        console.log('Connected to Redis on host ', process.env.REDIS_HOST)
    });

const app = express();
app.use(morgan('combined'));
app.use(express.json());
if (process.env.CORS === 'true') app.use(cors());

app.use('/api', router);

app.use(defaultErrorHandler);
app.listen(Number(process.env.PORT), () => {
    console.log('Server running on port ' + process.env.PORT);
});