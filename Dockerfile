# based on
# https://hub.docker.com/r/richarvey/nginx-php-fpm/
# and
# https://hub.docker.com/_/wordpress/

FROM richarvey/nginx-php-fpm:stable

MAINTAINER Miquel Adell <miquel@miqueladell.com>

# Add PHP repository to apt source
RUN echo "deb http://ppa.launchpad.net/ondrej/php5-5.6/ubuntu trusty main" \
        > /etc/apt/sources.list.d/php5-5.6.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-key E5267A6C



RUN apt-get update \
    && apt-get install -y \
        libpng12-dev \
        libjpeg-dev  \
        curl \
        sed

# are we missing mysqli?

WORKDIR /usr/share/nginx/html/
VOLUME /usr/share/nginx/html/

RUN rm index.html

ENV WORDPRESS_VERSION 4.4.1 #can we do that dynamic?

#COMPOSER
COPY files/composer.json composer.json
RUN echo "##################\n"
RUN ls -alR *
RUN find / -name 'composer.json'
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN composer update
RUN cat composer.json
RUN echo "##################\n"
RUN ls -alR *



# COPY BASE FILES
COPY files/.gitignore .gitignore
COPY files/index.php index.php
COPY files/wordpress/wp-config.custom.php wordpress/wp-config.custom.php
COPY scripts/docker-entrypoint.sh wordpress/entrypoint.sh
RUN echo "##################\n"
RUN ls -alR *
RUN find / -name 'wp-config.custom.php'

RUN echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n"
RUN composer update
RUN echo "##################\n"
RUN ls -alR *

# grr, ENTRYPOINT resets CMD now
# ENTRYPOINT ["wordpress/entrypoint.sh"]
# CMD ["php-fpm"]

ONBUILD RUN sed '/WP_DEBUG/ r /usr/share/nginx/html/wordpress/wp-config.custom.php' /usr/share/nginx/html/wordpress/wp-config.php > /usr/share/nginx/html/wordpress/tmp \
     && mv /usr/share/nginx/html/wordpress/tmp /usr/share/nginx/html/wordpress/wp-config.php \
     && rm /usr/share/nginx/html/wordpress/wp-config.custom.php


ONBUILD RUN chown -R www-data:www-data *
# can and should we automate the pull?
