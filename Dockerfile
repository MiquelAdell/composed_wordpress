#~~~ INFORMATION ~~~#

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
    && docker-php-ext-install \
        zip \
        mysqli

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer



#~~~ DIRS ~~~#

WORKDIR /var/www/html/
# VOLUME /var/www/html/



#~~~ WORDPRESS ~~~#

COPY files/composer.json composer.json
ONBUILD RUN composer update

#~ COPY BASE FILES ~#
# ONBUILD COPY files/.gitignore .gitignore
# ONBUILD COPY files/index.php index.php
# ONBUILD COPY files/wordpress/wp-config-custom.php wordpress/wp-config-custom.php
# ONBUILD COPY files/post-install-script.sh /var/www/html/wordpress/post-install-script.sh
#
# ONBUILD RUN /var/www/html/wordpress/post-install-script.sh
#
# ONBUILD RUN RUN chown -R www-data:www-data /var/www/html
#
# ONBUILD RUN RUN sed '/WP_DEBUG/ r /var/www/html/wordpress/wp-config-custom.php' /var/www/html/wordpress/wp-config.php > /var/www/html/wordpress/tmp \
#   && mv /var/www/html/wordpress/tmp /var/www/html/wordpress/wp-config.php \
#   && rm /var/www/html/wordpress/wp-config-custom.php
#
# ONBUILD RUN chown -R www-data:www-data /var/www/html
