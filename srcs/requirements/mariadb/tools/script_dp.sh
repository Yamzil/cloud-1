#!/bin/sh

service mysql start 
echo "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};" | mysql
echo "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" | mysql
echo "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' ;" | mysql
echo "ALTER USER '$MYSQL_ROOT_NAME'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';" | mysql
echo "FLUSH PRIVILEGES;" | mysql
mysqladmin -u "$MYSQL_ROOT_NAME" -p"$MYSQL_ROOT_PASSWORD" shutdown
mysqld_safe