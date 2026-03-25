#!/bin/sh
echo "Waiting for MySQL..."
until php -r "\$p=new PDO('mysql:host='.getenv('DB_HOST').';port='.(getenv('DB_PORT')?:3306), getenv('DB_USER'), getenv('DB_PASS'));" 2>/dev/null; do
  echo "MySQL not ready, retrying in 2s..."
  sleep 2
done
echo "MySQL is ready."

php think migrate:run
php think seed:run
php -S 0.0.0.0:80 -t public public/router.php
