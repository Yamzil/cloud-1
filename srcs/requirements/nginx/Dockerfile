FROM debian:buster

RUN  apt-get update;apt-get install -y --no-install-recommends nginx \
     openssl ; openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout \
     /etc/ssl/private/nginx-selfsigned.key \
     -out /etc/ssl/certs/nginx-selfsigned.crt \
     -subj '/CN=yamzil.42.fr/O=yamzil/L=Paris'

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]