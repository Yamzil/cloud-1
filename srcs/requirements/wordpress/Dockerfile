FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y \
        curl \
        php-fpm \
        php \
        php-mysql \
        mariadb-client && \
    rm -rf /var/lib/apt/lists/*

RUN curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp

RUN mkdir -p /var/www/html

RUN chown -R www-data:www-data /var/www/html

COPY tools/setup_wp.sh /usr/local/bin/setup_wp.sh
RUN chmod +x /usr/local/bin/setup_wp.sh

EXPOSE 9000

CMD ["/usr/local/bin/setup_wp.sh"]