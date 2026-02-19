# Use PHP CLI image (no Apache)
FROM php:8.2-cli

# Install required system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    libzip-dev libpng-dev libonig-dev libicu-dev \
    zip unzip curl git \
    && docker-php-ext-install gd intl zip pdo pdo_mysql

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Install PHP dependencies
RUN composer install --ignore-platform-reqs --optimize-autoloader --no-interaction

# 🚀 Additional Aimeos setup for public assets & demo data
RUN php artisan vendor:publish --tag=public --force \
 && php artisan vendor:publish --tag=assets --force \
 && php artisan storage:link \
 && php artisan aimeos:setup --option=setup/default/demo:1 --option=setup/default/languages:en,ru \
 && php artisan config:cache \
 && php artisan route:cache \
 && php artisan view:clear

# Expose Railway port
EXPOSE 8000

# Start PHP built-in server
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=${PORT}"]
