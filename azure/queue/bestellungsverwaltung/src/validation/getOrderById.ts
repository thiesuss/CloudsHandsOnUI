import { Schema } from "express-validator";

export default {
    id: {
        in: ['params'],
        exists: true,
        isInt: true,
        toInt: true
    }
} as Schema;