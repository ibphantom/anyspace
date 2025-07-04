FROM php:8.2-apache

RUN apt-get update && apt-get install -y unzip libzip-dev \
 && docker-php-ext-install mysqli pdo pdo_mysql zip

RUN a2enmod rewrite \
 && echo "DirectoryIndex index.php index.html" >> /etc/apache2/apache2.conf \
 && echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Set Document Root
ENV APACHE_DOCUMENT_ROOT=/var/www/anyspace/public

# Update Apache config with new root
RUN sed -ri 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/000-default.conf \
 && echo '<Directory "/var/www/anyspace/public">\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>' >> /etc/apache2/apache2.conf

# Copy app
COPY . /var/www/anyspace/

# Set permissions
RUN chown -R www-data:www-data /var/www/anyspace \
 && chmod -R 755 /var/www/anyspace

EXPOSE 80
CMD ["apache2-foreground"]
