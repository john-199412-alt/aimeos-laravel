FROM php:8.2-cli

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git curl libpng-dev libonig-dev libxml2-dev \
    libzip-dev libicu-dev zip unzip

# Install ALL required PHP extensions (including mbstring!)
RUN docker-php-ext-install \
    pdo_mysql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    gd \
    intl \
    zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app
COPY . .

# Install dependencies
RUN composer install --optimize-autoloader --no-dev --no-interaction

# Cache config
RUN php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache

EXPOSE 8080
CMD php artisan serve --host=0.0.0.0 --port=$PORT
