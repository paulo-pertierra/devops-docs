FROM node:20-alpine3.20 AS build

WORKDIR /client

COPY package.json package-lock.json ./

RUN npm ci

COPY . .

RUN npm run build

#-------
FROM nginx:1.27.2-alpine-slim AS miniprod

COPY --from=build /client/build /etc/nginx/html

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

ENTRYPOINT [ "nginx" ]

CMD [ "-g", "daemon off;" ]