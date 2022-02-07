FROM php:8.0-fpm-alpine3.15

ARG DEBUG
ARG XDEBUG_REMOTE_HOST
ENV COMPOSER_ALLOW_SUPERUSER=1
# Install needed packages
RUN apk update && \
    apk upgrade && \
    # Попробовать удалить после docker-php-ext-install
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
    echo "xdebug.force_display_errors=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.extended_info=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.log=/tmp/xdebug.log" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.client_host=$XDEBUG_REMOTE_HOST" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    cp "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"; \
    fi

COPY ./www.conf /usr/local/etc/php-fpm.d/www.conf

WORKDIR /var/www/cicd/

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

CMD ["php-fpm"]