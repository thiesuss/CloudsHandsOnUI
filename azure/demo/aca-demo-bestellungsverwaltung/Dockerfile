FROM node:20-alpine AS builder

WORKDIR /usr/src/app

COPY package*.json .

RUN npm ci

COPY . .

RUN npm run build

FROM node:20-alpine

ENV PORT 80
ENV CORS false
# the following env variable has to be given and be a valid URL
ENV INVENTORY_API_URL=
ENV NODE_ENV production
ENV REDIS_HOST ""
ENV REDIS_PORT=6380
ENV REDIS_PASS ""

USER node

WORKDIR /usr/src/app

COPY package*.json .

RUN npm ci --production

COPY --from=builder /usr/src/app/dist ./dist

EXPOSE 80
CMD [ "node", "dist/index.js" ]