import dotenv from 'dotenv';
import express, { NextFunction, Request, Response } from 'express';
import { Product } from './products';
import { productNamePriceValidateRules, productStockValidate, idParamValidate } from './validate'; 
import { body, validationResult } from 'express-validator'; 
import cors from 'cors';
import morgan from 'morgan';
//Importiert etwas womit alle übergebenen validierungsregeln in 
//einem Methodenaufruf abgearbeitet werden validationResult(req);

dotenv.config();
//app ist der Server, Router ist einfacherer Server. app kann mehrere Router besitzen
const app = express();
app.use(morgan('combined')); //Logging aktivieren
if(process.env.CORS === 'true'){
    app.use(cors()); 
}
app.use(express.json()); // Add this line to enable JSON parsing in the request body


let products: Product[] = [];

//Ein neues Produkt erstellen
app.post('/api/products', productNamePriceValidateRules, productStockValidate, (req: Request, res: Response) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ validationErrors: errors.array() });
    }
    
    const product: Product = {
        id: products.length +1,
        name: req.body.name,
        price: req.body.price,
        stock: req.body.stock,
    };

    products.push(product);
    res.status(201).json(product);
});

//Liste an Produkten antworten
app.get('/api/products', (req: Request, res: Response) => {
    res.json(products);
});

//Ein Produkt antworten oder keines -> Error
app.get('/api/products/:id', idParamValidate, (req: Request, res: Response) => {
    const errors = validationResult(req); // auf gültige id prüfen
    if (!errors.isEmpty()) { //Alle Fehlermelden
        return res.status(400).json({ validationErrors: errors.array() });
    }

    const product = products.find((p) => p.id === parseInt(req.params.id));

    if(!product) {
        
        res.status(404).json({ error:'Product does not exist!'});
    } else {
        res.json(product);
    }
});

app.patch('/api/products/:id', idParamValidate, productStockValidate, (req: Request, res: Response) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ validationErrors: errors.array() });
    }
        const product = products.find((p) => p.id === parseInt(req.params.id));

    if(!product) {
        
        res.status(404).json({ error:'Product does not exist!'});
    } else {

        product.stock = req.body.stock;

        res.json(product);
    }

});

app.delete('/api/products/:id', idParamValidate,(req: Request, res: Response) => {

    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ validationErrors: errors.array() });
    }

    const index = products.findIndex((p) => p.id === parseInt(req.params.id));

    if(index === -1) {
        
        res.status(404).json({ error:'Product does not exist!'});
    } else {
        products.splice(index, 1);
        res.status(204).send();
    }
});






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