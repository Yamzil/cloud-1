FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y \
        php-fpm \
        php-mysql \
        php-mbstring \
        php-zip \
        php-gd \
        php-xml \
        wget \
        unzip && \
    rm -rf /var/lib/apt/lists/*

RUN wget -q https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.zip \
        -O /tmp/phpmyadmin.zip && \
    unzip -q /tmp/phpmyadmin.zip -d /tmp/ && \
    mv /tmp/phpMyAdmin-5.2.1-all-languages /var/www/phpmyadmin && \
    rm /tmp/phpmyadmin.zip

COPY conf/config.inc.php /var/www/phpmyadmin/config.inc.php

RUN chown -R www-data:www-data /var/www/phpmyadmin

COPY tools/start_pma.sh /usr/local/bin/start_pma.sh
RUN chmod +x /usr/local/bin/start_pma.sh

EXPOSE 9001

CMD ["/usr/local/bin/start_pma.sh"]
