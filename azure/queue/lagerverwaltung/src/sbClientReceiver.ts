import { DefaultAzureCredential } from "@azure/identity";
import { ServiceBusClient } from "@azure/service-bus";
import dotenv from 'dotenv';

dotenv.config(); 

if (!process.env.AZ_SERVICE_BUS_STOCK_QUEUE) {
    throw new Error('Environment variable AZ_SERVICE_BUS_STOCK_QUEUE not set.');
}

export let sbClient: ServiceBusClient;
if (process.env.AZ_SERVICE_BUS_CONNECTIONSTRING) {
    console.log('Trying to connect to Service Bus via Connection String');
    sbClient = new ServiceBusClient(process.env.AZ_SERVICE_BUS_CONNECTIONSTRING);
} else {
    console.log('Trying to connect to Service Bus via Default Credentials');
    if (!process.env.AZ_SERVICE_BUS_NAMESPACE) {
        throw new Error('Environment variable AZ_SERVICE_BUS_NAMESPACE not set.');
    }
    const credentials = new DefaultAzureCredential();
    const fqNamespace = `${process.env.AZ_SERVICE_BUS_NAMESPACE}.servicebus.windows.net`;
    sbClient = new ServiceBusClient(fqNamespace, credentials);
}
console.log('Connected to Service Bus');

export const stockReceiver = sbClient.createReceiver(process.env.AZ_SERVICE_BUS_STOCK_QUEUE);

