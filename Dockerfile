FROM node:alpine as builder

WORKDIR "/app"

COPY ./package.json ./

RUN npm install

COPY . .

RUN npm run build

FROM nginx:1.15.10
COPY ./nginx/default.conf.template /etc/nginx/conf.d/default.conf.template
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /app/build /usr/share/nginx/html 
CMD /bin/bash -c "envsubst '\$PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf" && nginx -g 'daemon off;'