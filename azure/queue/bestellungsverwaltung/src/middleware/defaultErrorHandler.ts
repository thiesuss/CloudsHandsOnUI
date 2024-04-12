import { ErrorRequestHandler } from "express";
import ApiError from "../ApiError";
const defaultErrorHandler: ErrorRequestHandler = function (err, req, res, next) {
    if (err instanceof ApiError) {
        res.status(err.httpCode);
        return res.json({ error: err.message });
    }

    console.error(err);
    res.status(500);
    return res.json({ error: 'Internal Server error' });
};

export default defaultErrorHandler;