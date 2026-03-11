#!/bin/sh

PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")

sed -i "s|listen = /run/php/php${PHP_VERSION}-fpm.sock|listen = 9001|" \
    /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf

PMA_DST="/var/www/html/phpmyadmin"
PMA_SRC="/usr/src/phpmyadmin"

# Copy phpMyAdmin into the shared web volume once
if [ ! -f "$PMA_DST/index.php" ]; then
    mkdir -p "$PMA_DST"
    cp -a "$PMA_SRC/." "$PMA_DST/"
    chown -R www-data:www-data "$PMA_DST"
fi

mkdir -p /run/php
mkdir -p /tmp/phpmyadmin_tmp
chown www-data:www-data /tmp/phpmyadmin_tmp

exec php-fpm${PHP_VERSION} -F -R
