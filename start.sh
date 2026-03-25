#!/bin/sh
echo "Waiting for MySQL..."
until php -r "new PDO('mysql:host='.\$_SERVER['DB_HOST'].';port='.(\$_SERVER['DB_PORT']??3306), \$_SERVER['DB_USER'], \$_SERVER['DB_PASS']);" 2>/dev/null; do
  echo "MySQL not ready, retrying in 2s..."
  sleep 2
done
echo "MySQL is ready."

php think migrate:run
php think seed:run
php -S 0.0.0.0:80 -t public public/router.php
