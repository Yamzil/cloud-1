#!/bin/sh

PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")

sed -i "s|listen = /run/php/php${PHP_VERSION}-fpm.sock|listen = 9001|" \
    /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf

mkdir -p /run/php
mkdir -p /tmp/phpmyadmin_tmp
chown www-data:www-data /tmp/phpmyadmin_tmp

exec php-fpm${PHP_VERSION} -F -R
