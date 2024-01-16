import dotenv from 'dotenv';
import express, { NextFunction, Request, Response } from 'express';
import { Product } from './types';
import { productNamePriceValidateRules, productStockValidate, idParamValidate } from './validate'; 
import * as azureInsights from 'applicationinsights';
import cors from 'cors';
import morgan from 'morgan';
//Importiert etwas womit alle übergebenen validierungsregeln in 
//einem Methodenaufruf abgearbeitet werden validationResult(req);

dotenv.config();

if (process.env.AZ_INSIGHTS_CONNECTIONSTRING) {
    console.log('Starting Application Insights');
    azureInsights.setup(process.env.AZ_INSIGHTS_CONNECTIONSTRING)
        .setDistributedTracingMode(azureInsights.DistributedTracingModes.AI_AND_W3C);
    azureInsights.defaultClient.context.tags[azureInsights.defaultClient.context.keys.cloudRole] = 'lagerverwaltung';
    azureInsights.start();
}
import { init } from "./receiverHandler";

//app ist der Server, Router ist einfacherer Server. app kann mehrere Router besitzen
const app = express();
app.use(morgan('combined')); //Logging aktivieren
if(process.env.CORS === 'true'){
    app.use(cors()); 
}
app.use(express.json()); // Add this line to enable JSON parsing in the request body

init(); //receiver Anbinden

export let products: Product[] = [];

import postProduct from './postProduct';
//Ein neues Produkt erstellen
app.post('/api/products', productNamePriceValidateRules, productStockValidate, postProduct);

import getAllProducts from './getAllProducts'; //auslagern der Function
//Liste an Produkten antworten
app.get('/api/products', getAllProducts); //function als default daher einfach der Name der Datei

import getIdProduct from './getIdProduct';
//Ein Produkt antworten oder keines -> Error
app.get('/api/products/:id', idParamValidate, getIdProduct);

import patchIdProduct from './patchIdProduct';
//vorhandenes Product ändern
app.patch('/api/products/:id', idParamValidate, productStockValidate, patchIdProduct);

import deleteIdProduct from './deleteIdProduct';
//product loeschen
app.delete('/api/products/:id', idParamValidate,deleteIdProduct);










app.listen(Number(process.env.PORT), () => {
    console.log("Server running on port " + process.env.PORT);
});

// Add this error handling middleware
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
    console.error(err.stack);
    res.status(500).send('Internal Server error');
  });

// const task = tasks.find((t) => t.id === parseInt(req.params.id));

// tasks ist eine selbst angelegte Liste in der wir den Wert speichern in welchem t.id 
//der id entspricht und req.params.id die als Parameter übergeben id ausliest 
//(parseint moeglich hier nicht geprüft) falls id body dann .body.  statt .param. 