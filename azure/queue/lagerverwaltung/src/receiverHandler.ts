
import {stockReceiver} from "./sbClientReceiver"
import {products} from "./index";
import {ServiceBusMessage, ProcessErrorArgs, delay} from "@azure/service-bus";
import {ChangeStockMessage} from "./types"


// function to handle messages
const myMessageHandler = async (messageReceived: ServiceBusMessage) => {
    await delay(10000);
    console.log(`Received message: ${messageReceived.body}`);
    
    processElement(messageReceived);
    
};

// function to handle any errors
const myErrorHandler = async (error: ProcessErrorArgs) => {
    console.log(error);
};

// subscribe and specify the message and error handlers
export const init = () => {
    stockReceiver.subscribe({
        processMessage: myMessageHandler,
        processError: myErrorHandler
    });
}

const processElement = (element: ChangeStockMessage) => {
    const increase = element.body.type === "incr";
    const productId = element.body.productId; 
    const stockValue = element.body.amount; 


    const product = products.find((p) => p.id === productId);

    if (!product) {
        console.error(`Product ${productId} not found`);
        return;
    }
    if(increase) {
        product.stock += stockValue;
    } else {
        product.stock -= stockValue;
    }
    console.log(`Processed product ${productId} - New stock: ${product.stock}`);
};

