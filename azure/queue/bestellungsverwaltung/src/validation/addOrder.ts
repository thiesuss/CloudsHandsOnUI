import { Schema } from "express-validator";
export default {
    customer: {
        in: ['body'],
        exists: true,
        isEmpty: { negated: true },
        trim: true
    },
    items: {
        in: ['body'],
        exists: true,
        isArray: {
            options: { min: 1 }
        }
    },
    'items.*.id': {
        exists: true,
        isInt: {
            options: { min: 1 }
        },
        toInt: true
    },
    'items.*.quantity': {
        exists: true,
        isInt: {
            options: { min: 1 }
        },
        toInt: true
    }
} as Schema;