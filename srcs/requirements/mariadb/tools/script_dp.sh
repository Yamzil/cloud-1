#!/bin/sh
set -e

DATA_DIR="/var/lib/mysql"

# Idempotency check
if [ -d "$DATA_DIR/wordpress" ] || [ -d "$DATA_DIR/${MYSQL_DATABASE}" ]; then
    echo "Already initialized. Starting MariaDB..."
    exec mysqld_safe \
        --bind-address=0.0.0.0 \
        --port=3306
fi

echo "First run. Initializing database..."

# Initialize data directory if needed
if [ ! -d "$DATA_DIR/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=$DATA_DIR
fi

# Start MariaDB temporarily for setup
# --skip-networking: no TCP during init (safe)
# --skip-grant-tables: bypass auth to set root password
mysqld_safe --skip-networking --skip-grant-tables &
MYSQL_PID=$!

echo "Waiting for MariaDB socket..."
for i in $(seq 1 30); do
    if mysqladmin ping --silent 2>/dev/null; then
        echo "Ready after ${i}s."
        break
    fi
    sleep 1
done

if ! mysqladmin ping --silent 2>/dev/null; then
    echo "ERROR: MariaDB failed to start"
    exit 1
fi

echo "Running initialization SQL..."
mysql --protocol=socket << EOSQL
FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user
    WHERE User='root'
    AND Host NOT IN ('localhost', '127.0.0.1', '::1');

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%'
    IDENTIFIED BY '${MYSQL_PASSWORD}';

GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.*
    TO '${MYSQL_USER}'@'%';

ALTER USER 'root'@'localhost'
    IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

FLUSH PRIVILEGES;
EOSQL

echo "Database initialized successfully."
echo "Created database: ${MYSQL_DATABASE}"
echo "Created user: ${MYSQL_USER}"

# Stop temporary instance
echo "Stopping temporary MariaDB..."
kill $MYSQL_PID
wait $MYSQL_PID 2>/dev/null
sleep 3

# Start MariaDB in production mode
# --bind-address=0.0.0.0 = listen on ALL interfaces (TCP)
# This is what allows other containers to connect
echo "Starting MariaDB in production mode (TCP enabled)..."
exec mysqld_safe \
    --bind-address=0.0.0.0 \
    --port=3306