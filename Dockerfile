# Use PHP CLI image (no Apache)
FROM php:8.2-cli

# Install required system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    libonig-dev \
    libicu-dev \
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

# Expose port (just documentation)
EXPOSE 8000

# 🔥 AUTO RUN MIGRATIONS + START SERVER
CMD php artisan migrate --force && php artisan aimeos:setup --env=production && php artisan serve --host=0.0.0.0 --port=${PORT}
