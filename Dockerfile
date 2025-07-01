FROM php:8.2-apache

# Enable required PHP extensions
RUN apt-get update && apt-get install -y libzip-dev unzip \
    && docker-php-ext-install mysqli pdo pdo_mysql zip

# Enable Apache mod_rewrite and set DirectoryIndex
RUN a2enmod rewrite \
    && echo "DirectoryIndex index.php index.html" >> /etc/apache2/apache2.conf

# Set working directory and copy public-facing files
WORKDIR /var/www/html
COPY public/ /var/www/html/

# Set permissions
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

EXPOSE 80
CMD ["apache2-foreground"]
