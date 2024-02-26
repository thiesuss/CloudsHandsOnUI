export default class ApiError extends Error {
    httpCode: number = 500;
    constructor(message: string, httpCode: number) {
        super(message);
        this.httpCode = httpCode;
    }
}