#!/bin/bash

MYSQL_PWD='Aditya'
MYSQL_CMD="mysql -u root -p${MYSQL_PWD}"

echo "Checking if MySQL is already installed..."
if command -v mysql >/dev/null 2>&1; then
    echo "MySQL is already installed. Skipping installation."
else
    echo "Installing MySQL server..."
    sudo apt update
    sudo apt install mysql-server -y
fi

echo "Testing MySQL login with root password..."
if ${MYSQL_CMD} -e ";" >/dev/null 2>&1; then
    echo "Successfully authenticated. Skipping password reset."
else
    echo "Root password not working. Trying to set password using socket authentication..."
    sudo mysql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_PWD}';
FLUSH PRIVILEGES;
EOF
fi

echo "Creating database and user table..."
${MYSQL_CMD} <<EOF
CREATE DATABASE IF NOT EXISTS crud_app;
USE crud_app;

DROP TABLE IF EXISTS users;

CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE,
  password VARCHAR(255) NOT NULL,
  role ENUM('admin','viewer') NOT NULL DEFAULT 'viewer',
  is_active TINYINT(1) DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
EOF

echo "✅ MySQL setup and table creation completed successfully."
