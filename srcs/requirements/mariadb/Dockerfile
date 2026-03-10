FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*


RUN echo "[mysqld]\nbind-address = 0.0.0.0" > \
    /etc/mysql/mariadb.conf.d/99-bind-address.cnf

COPY tools/script_dp.sh /usr/local/bin/script_dp.sh

RUN chmod +x /usr/local/bin/script_dp.sh

EXPOSE 3306

CMD ["/usr/local/bin/script_dp.sh"]
