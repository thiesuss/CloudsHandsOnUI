FROM node:20-alpine AS builder

WORKDIR /usr/src/app

COPY package*.json .

RUN npm ci

COPY . .

RUN npm run build

FROM node:20-alpine

ENV PORT 80
ENV CORS false
ENV NODE_ENV production
ENV REDIS_HOST ""
ENV REDIS_PORT=6380
ENV REDIS_PASS ""

ENV BLOB_ACCOUNT_URL ""
ENV BLOB_CONTAINER_NAME ""
ENV BLOB_SAS_UPLOAD_TOKEN ""

USER node

WORKDIR /usr/src/app

COPY package*.json .

RUN npm ci --production

COPY --from=builder /usr/src/app/dist ./dist

EXPOSE 80
CMD [ "node", "dist/index.js" ]