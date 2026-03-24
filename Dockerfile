FROM php:8.1-cli

# 安装 PHP 扩展
RUN apt-get update && apt-get install -y \
    libzip-dev libonig-dev libssl-dev unzip curl libpng-dev libjpeg-dev libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql mysqli mbstring zip fileinfo opcache gd \
    && apt-get clean

# 安装 Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app
COPY . .

RUN composer update --no-dev --optimize-autoloader --no-audit

# 删除 .env，让容器使用环境变量
# RUN rm -f .env

EXPOSE 80

CMD php think migrate:run && php think seed:run && php -S 0.0.0.0:80 -t public public/router.php
