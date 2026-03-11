#!/bin/sh

PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
echo "PHP version: $PHP_VERSION"

sed -i "s|listen = /run/php/php${PHP_VERSION}-fpm.sock|listen = 9000|" \
    /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf

WP_DIR="/var/www/html"

mkdir -p "$WP_DIR"

if [ ! -f "$WP_DIR/wp-config.php" ]; then
    echo "WordPress not found. Installing..."

    wp core download \
        --allow-root \
        --path="$WP_DIR"

    wp config create \
        --allow-root \
        --path="$WP_DIR" \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost=mariadb \
        --dbcharset=utf8 \
        --skip-check

    echo "Waiting for MariaDB..."
    until wp db check \
        --allow-root \
        --path="$WP_DIR" \
        --dbhost=mariadb \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" >/dev/null 2>&1; do
        echo "MariaDB not ready yet, waiting..."
        sleep 2
    done
    echo "MariaDB is ready."

    if ! wp core is-installed --allow-root --path="$WP_DIR" >/dev/null 2>&1; then
        echo "Running non-interactive WordPress installation..."
        wp core install \
            --allow-root \
            --path="$WP_DIR" \
            --url="https://$DOMAIN_NAME" \
            --title="Cloud-1 WordPress" \
            --admin_user="$WP_ADMIN_USER" \
            --admin_password="$WP_ADMIN_PASSWORD" \
            --admin_email="$WP_ADMIN_EMAIL" \
            --skip-email
    else
        echo "WordPress DB already installed. Skipping core install."
    fi

    chown -R www-data:www-data "$WP_DIR"
    echo "WordPress installed and configured."
else
    echo "WordPress already installed. Skipping."
fi

mkdir -p /run/php
exec php-fpm${PHP_VERSION} -F -R