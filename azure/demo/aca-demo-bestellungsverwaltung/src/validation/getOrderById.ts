import { Schema } from "express-validator";

export default {
    id: {
        in: ['params'],
        exists: true,
        isUUID: { version: 4 }
    }
} as Schema;