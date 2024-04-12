import { Schema, checkSchema } from "express-validator";
import validationErrorHandler from "./validationErrorHandler";

export default function schemaHandler(schema: Schema) {
    return [checkSchema(schema), validationErrorHandler];
}