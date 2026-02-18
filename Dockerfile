# Your Dockerfile content here
@"
# Use official PHP 8.2 image with Apache
FROM php:8.2-apache

# Install system dependencies and PHP extensions required by Aimeos
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    libonig-dev \
    libicu-dev \
    zip unzip curl git \
    && docker-php-ext-install gd intl zip opcache pdo pdo_mysql

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy project files
COPY . .

# Install PHP dependencies
RUN composer install --ignore-platform-reqs --optimize-autoloader --no-inte
