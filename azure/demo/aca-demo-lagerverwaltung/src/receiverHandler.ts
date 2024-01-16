import * as azureInsights from "applicationinsights";
import { stockReceiver } from "./sbClientReceiver"
import { ServiceBusMessage, ProcessErrorArgs, delay, ServiceBusReceivedMessage } from "@azure/service-bus";
import { ChangeStockMessage } from "./types"
import { CorrelationContextManager } from "applicationinsights/out/AutoCollection/CorrelationContextManager";
import redis from './redis';


const messageHandlerWrapper = (handler: (msg: ServiceBusReceivedMessage) => Promise<void>) => {
    return async (message: ServiceBusReceivedMessage) => {
        const traceParent = message.applicationProperties;
        const diagnosticId = traceParent?.['Diagnostic-Id'] as string | null;
        console.log(diagnosticId);

        
        if (!traceParent || !diagnosticId) {
            console.log('no');
            await handler(message);
            return;
        }
        
        
        const [_, traceId, spanId, _a] = diagnosticId?.split('-');
        //azureInsights.getCorrelationContext().operation.traceparent;
        const context = CorrelationContextManager.generateContextObject(
            traceId,
            spanId,
            'ServiceBus.process',
        );

        
        const fn = azureInsights.wrapWithCorrelationContext(async () => await handler(message), context);
        await fn();
    };
};

// function to handle messages
const myMessageHandler = async (messageReceived: ServiceBusMessage) => {
    await delay(10000);
    console.log(`Received message: ${messageReceived.body}`);

    await processElement(messageReceived);

};

// function to handle any errors
const myErrorHandler = async (error: ProcessErrorArgs) => {
    console.log(error);
};

// subscribe and specify the message and error handlers
export const init = () => {
    stockReceiver.subscribe({
        processMessage: messageHandlerWrapper(myMessageHandler),
        processError: myErrorHandler
    });
}

const processElement = async (element: ChangeStockMessage) => {
    const increase = element.body.type === "incr";
    const productId = element.body.productId;
    const stockValue = element.body.amount;

// TODO
    try {
        const exists = await redis.hExists('inventory:items:' + productId, 'stock');
        if (exists) {
            await redis.hIncrBy('inventory:items:'+ productId, 'stock', increase ? stockValue : -stockValue);
            

        } else {
            console.error('Product does not exist!');
        }
    } catch (error) {
        console.error('Fehler beim Update');
    }

    
    console.log(`Processed product ${productId} stock updated`);
};

