FROM php:8.0-fpm-alpine3.15

ENV COMPOSER_ALLOW_SUPERUSER=1
# Install needed packages
RUN apk update && \
    apk upgrade && \
    apk add openssh-server && \
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
     libzip-dev && \
    pecl install xdebug-3.1.3 && \
    docker-php-ext-configure gd --enable-gd --with-freetype && \
    docker-php-ext-enable xdebug && \
    docker-php-ext-install gd pdo_pgsql curl opcache xml zip && \
    docker-php-source delete
COPY entrypoint.sh /entrypoint.sh
RUN mkdir /var/run/sshd && \
    echo 'root:cicd' | chpasswd && \
    echo 'cicd:cicd' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

RUN  \
    echo "xdebug.force_display_errors=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.extended_info=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.log=/tmp/xdebug.log" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    # TODO XDEBUG_CONFIG
    echo "" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    cp "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

COPY ./www.conf /usr/local/etc/php-fpm.d/www.conf

# Configure FPM to run properly on docker
RUN sed -i "/pid = .*/c\pid = /var/run/php7.2-fpm.pid" /usr/local/etc/php-fpm.conf && \
    sed -i "/;daemonize = .*/c\daemonize = no" /usr/local/etc/php-fpm.conf && \
    sed -i "/error_log = .*/c\error_log = /proc/self/fd/2" /usr/local/etc/php-fpm.conf

WORKDIR /var/www/cicd/

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

CMD ["php-fpm"]