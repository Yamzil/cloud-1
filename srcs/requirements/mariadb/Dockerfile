FROM debian:bookworm

WORKDIR /usr/local/bin

RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

COPY tools/script_dp.sh /usr/local/bin/script_dp.sh

RUN chmod +x /usr/local/bin/script_dp.sh

EXPOSE 3306

CMD ["/usr/local/bin/script_dp.sh"]