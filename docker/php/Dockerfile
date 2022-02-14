FROM php:8.0-fpm-alpine3.15

ARG DEBUG
ARG XDEBUG_REMOTE_HOST
ENV COMPOSER_ALLOW_SUPERUSER=1
# Установка программ
RUN apk update && \
    apk upgrade && \
    apk add \
    postgresql-dev  \
    libxml2-dev  \
    curl-dev  \
    libpng-dev  \
    autoconf  \
    gcc  \
    g++  \
    make  \
    libffi-dev  \
    openssl-dev \
    openssh-sftp-server \
    freetype-dev \
    shadow \
    sudo \
    git \
    libzip-dev && \
    pecl install xdebug-3.1.3 && \
    docker-php-ext-configure gd --enable-gd --with-freetype && \
    docker-php-ext-enable xdebug && \
    docker-php-ext-install gd pdo_pgsql curl opcache xml zip && \
    docker-php-source delete

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

RUN if [[ ${DEBUG} == "true" ]]; then \
    XDEBUG_CONFIG=$PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini &&  \
    echo "xdebug.extended_info=1" >> $XDEBUG_CONFIG && \
    echo "xdebug.idekey=PHPSTORM" >> $XDEBUG_CONFIG && \
    echo "xdebug.log=/tmp/xdebug.log" >> $XDEBUG_CONFIG && \
    echo "xdebug.mode=debug" >> $XDEBUG_CONFIG && \
    echo "xdebug.client_host=$XDEBUG_REMOTE_HOST" >> $XDEBUG_CONFIG && \
    cp "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"; \
    fi

COPY ./www.conf /usr/local/etc/php-fpm.d/www.conf

WORKDIR /var/www/cicd/

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

CMD ["php-fpm"]