# Use the official PHP image with version 8.2.12
FROM php:8.2.12

# Set working directory
WORKDIR /var/www/html

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
        git \
        curl \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
        zip \
        unzip \
        && docker-php-ext-configure gd --with-freetype --with-jpeg \
        && docker-php-ext-install -j$(nproc) gd \
        && docker-php-ext-install pdo_mysql

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy application files
COPY . .

# Install PHP dependencies
RUN composer install --ignore-platform-reqs --no-interaction --no-plugins --no-scripts

# Expose port 80
EXPOSE 80

# Start PHP server
CMD ["php", "artisan", "serve", "--host", "0.0.0.0", "--port", "80"]
