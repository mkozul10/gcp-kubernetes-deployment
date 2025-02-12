FROM node:20-bullseye-slim AS development

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

FROM node:20-bullseye-slim AS production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install --only=production

COPY . .
COPY --from=development /usr/src/app/dist ./dist

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

CMD ["node", "dist/main"]
