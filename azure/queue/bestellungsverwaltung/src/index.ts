import dotenv from 'dotenv';
import express from 'express';
import cors from 'cors';
import morgan from 'morgan';
import defaultErrorHandler from './middleware/defaultErrorHandler';
import * as azureInsights from 'applicationinsights';


import InventoryService from './services/InventoryService';

dotenv.config();

if (process.env.AZ_INSIGHTS_CONNECTIONSTRING) {
    console.log('Starting Application Insights');
    azureInsights.setup(process.env.AZ_INSIGHTS_CONNECTIONSTRING)
        .setDistributedTracingMode(azureInsights.DistributedTracingModes.AI_AND_W3C);
    azureInsights.defaultClient.context.tags[azureInsights.defaultClient.context.keys.cloudRole] = 'bestellverwaltung';
    azureInsights.start();
}

import router from './router';

if (!process.env.INVENTORY_API_URL) {
    throw new Error('Environment variable INVENTORY_API_URL must be defined!');
}

export const inventoryService = new InventoryService(process.env.INVENTORY_API_URL);

const app = express();
app.use(morgan('combined'));
app.use(express.json());
if (process.env.CORS === 'true') app.use(cors());

app.use('/api', router);

app.use(defaultErrorHandler);
app.listen(Number(process.env.PORT), () => {
    console.log('Server running on port ' + process.env.PORT);
});