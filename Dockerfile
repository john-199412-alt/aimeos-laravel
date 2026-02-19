# Use PHP CLI image (no Apache)
FROM php:8.2-cli

# Install required system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    libonig-dev \
    libicu-dev \
    zip \
    unzip \
    curl \
    git \
    && docker-php-ext-install gd intl zip pdo pdo_mysql

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Install PHP dependencies
RUN composer install --no-interaction --optimize-autoloader --ignore-platform-reqs

# Set proper permissions for Laravel
RUN chmod -R 775 storage bootstrap/cache

# Expose port (Railway ignores this but good practice)
EXPOSE 8000

# Run migrations, seed the database, perform Aimeos setup, then start server
CMD php artisan migrate --force \
    && php artisan db:seed --force \
    && php artisan aimeos:setup --env=production \
    && php artisan serve --host=0.0.0.0 --port=${PORT}
