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

USER node

WORKDIR /usr/src/app

COPY package*.json .

RUN npm ci --production

COPY --from=builder /usr/src/app/dist ./dist

EXPOSE 80
CMD [ "node", "dist/index.js" ]