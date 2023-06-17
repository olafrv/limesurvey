FROM php:7.2.11-apache
LABEL mantainer="Olaf Reitmaier <olafrv@gmail.com>"

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libc-client-dev \
        libkrb5-dev \
        libldap-dev \
        libzip-dev \
    && rm -r /var/lib/apt/lists/* \
		&& apt-get clean \
		&& docker-php-source extract \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl && docker-php-ext-install imap \
    && docker-php-ext-install pdo pdo_mysql mysqli ldap zip \
		&& docker-php-source delete

WORKDIR /var/www/html/limesurvey
COPY limesurvey .
RUN chmod -R 777 ./tmp \
		&& chmod -R 777 ./upload \
		&& chmod -R 777 ./application/config
