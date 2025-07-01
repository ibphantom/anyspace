FROM php:8.2-apache

# Enable PHP extensions
RUN apt-get update && apt-get install -y unzip libzip-dev \
    && docker-php-ext-install mysqli pdo pdo_mysql zip

# Enable mod_rewrite and set index preference
RUN a2enmod rewrite \
    && echo "DirectoryIndex index.php index.html" >> /etc/apache2/apache2.conf

# Copy full app (not just public/)
COPY . /var/www/anyspace/

# Point Apache to serve from public/
ENV APACHE_DOCUMENT_ROOT=/var/www/anyspace/public

# Adjust Apache config to use new document root
RUN sed -ri 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/000-default.conf

# Set permissions
RUN chown -R www-data:www-data /var/www/anyspace

EXPOSE 80
CMD ["apache2-foreground"]
