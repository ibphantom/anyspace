# Use PHP with Apache  
FROM php:8.2-apache

# Install dependencies  
RUN apt-get update && apt-get install -y git unzip libzip-dev \
    && docker-php-ext-install mysqli pdo pdo_mysql zip \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache rewrite  
RUN a2enmod rewrite

# Copy source and set permissions  
COPY . /var/www/html/
RUN chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && find /var/www/html -type f -exec chmod 644 {} \;

# Expose HTTP  
EXPOSE 80

CMD ["apache2-foreground"]
