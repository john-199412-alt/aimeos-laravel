FROM php:8.2-cli

RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    libonig-dev \
    libicu-dev \
    zip \
    unzip \
    curl \
    git \
    && docker-php-ext-install \
        gd \
        intl \
        zip \
        pdo \
        pdo_mysql \
        mbstring

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app

COPY . .

RUN composer install --no-interaction --optimize-autoloader

RUN chmod -R 775 storage bootstrap/cache

EXPOSE 8000

CMD php artisan migrate --force \
    && php artisan db:seed --force \
    && php artisan aimeos:setup --env=production \
    && php artisan serve --host=0.0.0.0 --port=${PORT}
