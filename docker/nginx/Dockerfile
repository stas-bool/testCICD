FROM nginx:1.21.6-alpine

ARG APP_NAME

COPY example-vhost.conf /etc/nginx/vhosts/vhost.conf
RUN sed -i "s/\${APP_NAME}/$APP_NAME/g" /etc/nginx/vhosts/vhost.conf
