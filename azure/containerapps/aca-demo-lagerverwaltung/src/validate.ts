import { body } from 'express-validator';

export const productNamePriceValidateRules = [
    body('name','"name" is empty').notEmpty(),
    body('name','Expected type of parameter "name" is String, got another type instead!').isString(),
    body('price','"price is empty').notEmpty(),
    body('price','Expected type of parameter "price" is numeric, got another type instead!').isNumeric(),
];

export const productStockValidate = [
    body('stock','"stock" is empty').notEmpty(),
    body('stock','Expected type of parameter "stock" is Number (integer positiv), got another type instead!').isInt({min: 0})
];
import { param } from 'express-validator';
export const idParamValidate = [
    param('id','"id" is empty').notEmpty(),
    param('id','Expected type of parameter "id" is Number (integer), got another type instead!').isInt()
];

