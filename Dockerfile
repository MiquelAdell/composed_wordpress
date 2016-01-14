FROM php:5.6-fpm
MAINTAINER Miquel Adell <miquel@miqueladell.com>

# install the PHP extensions we need
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev && rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mysqli opcache

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

VOLUME /var/www/html

ENV WORDPRESS_VERSION 4.4.1
ENV WORDPRESS_SHA1 be7224551b45fdddf696142b4f4a6f609b57e323

RUN curl -o wordpress.tar.gz -SL https://github.com/johnpbloch/wordpress/archive/${WORDPRESS_VERSION}.tar.gz \
	&& echo "${WORDPRESS_SHA1} *wordpress.tar.gz" | sha1sum -c - \
	&& tar -xzf wordpress.tar.gz -C /usr/src/ \
	&& mv /usr/src/wordpress-${WORDPRESS_VERSION} /usr/src/wordpress \
	&& rm wordpress.tar.gz \
	&& chown -R www-data:www-data /usr/src/wordpress

COPY docker-wp-config.custom.php /var/www/html/wp-config.custom.php

COPY docker-entrypoint.sh /entrypoint.sh

# grr, ENTRYPOINT resets CMD now
ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm"]

ONBUILD RUN sed '/WP_DEBUG/ r /var/www/html/wp-config.custom.php' /var/www/html/wp-config.php > /var/www/html/tmp \
    && mv /var/www/html/tmp /var/www/html/wp-config.php

ONBUILD RUN rm /var/www/html/wp-config.custom.php
