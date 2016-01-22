#~~~ INFORMATION ~~~#
# VERSION 0.0.2

# based on
# https://hub.docker.com/r/richarvey/nginx-php-fpm/
# and
# https://hub.docker.com/_/wordpress/

FROM php:7.0.2-apache

MAINTAINER Miquel Adell <miquel@miqueladell.com>

ENV WORDPRESS_VERSION 4.4.1 #can we do that dynamic?



#~~~ DEPENDENCIES ~~~#

# Add PHP repository to apt source
RUN apt-get update \
    && apt-get install -y \
        libpng12-dev \
        libjpeg-dev  \
        curl \
        sed \
        zlib1g-dev \
        rsync \
    && docker-php-ext-install \
        zip \
        mysqli

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer



#~~~ VOLUMES ~~~#

RUN mkdir /tmp/html
WORKDIR /tmp/html



#~~~ WORDPRESS ~~~#

COPY files/composer.json composer.json
RUN composer update

#~ COPY BASE FILES ~#
COPY files/.gitignore .gitignore
COPY files/index.php index.php
COPY files/wordpress/wp-config-custom.php wordpress/wp-config-custom.php

RUN chown -R www-data:www-data /tmp/html



#~~~ MOVE FILES TO THE VOLUME ~~~#

VOLUME /var/www/html/
WORKDIR /var/www/html/

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm"]
