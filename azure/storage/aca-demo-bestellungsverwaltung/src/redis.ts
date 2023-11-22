import dotenv from 'dotenv';
import { createClient } from "redis";

dotenv.config();

const client = createClient({
    socket: {
        host: process.env.REDIS_HOST,
        port: parseInt(process.env.REDIS_PORT || '6380'),
        tls: true
    },
    password: process.env.REDIS_PASS
})
client.on('error', e => {
    console.error('Redis Client Error', e);
});

export default client;