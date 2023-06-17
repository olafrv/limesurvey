# https://manual.limesurvey.org/Installation_-_LimeSurvey_CE

FROM php:8.2.7-apache
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
    && docker-php-ext-configure gd \ 
    && docker-php-ext-install -j$(nproc) gd \ 
    && docker-php-ext-configure gd --with-jpeg=/usr/include/ --with-freetype=/usr/include/ \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl && docker-php-ext-install imap \
    && docker-php-ext-install pdo pdo_mysql mysqli ldap zip \
		&& docker-php-source delete

WORKDIR /var/www/html/limesurvey
COPY limesurvey .
RUN chmod -R 777 ./tmp \
		&& chmod -R 777 ./upload \
		&& chmod -R 777 ./application/config
