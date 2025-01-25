# Use the official PHP image as a base image
FROM php:7.4-apache

# Copy your PHP application files to the /var/www/smartchat directory in the container
COPY ./smartchat /var/www/smartchat

# Set the working directory inside the container
WORKDIR /var/www/smartchat

# Expose port 80
EXPOSE 80

# Install necessary PHP extensions
RUN docker-php-ext-install mysqli

# Set permissions for the Apache web server to access your files
RUN chown -R www-data:www-data /var/www/smartchat
RUN chmod -R 755 /var/www/smartchat

# Enable the rewrite module (if needed)
RUN a2enmod rewrite

# Update the Apache configuration to use /var/www/smartchat as the document root
RUN echo '<VirtualHost *:80>\n DocumentRoot /var/www/smartchat\n <Directory /var/www/smartchat>\n Options Indexes FollowSymLinks\n AllowOverride All\n Require all granted\n </Directory>\n ErrorLog ${APACHE_LOG_DIR}/error.log\n CustomLog ${APACHE_LOG_DIR}/access.log combined\n</VirtualHost>' > /etc/apache2/sites-available/000-default.conf

# Start the Apache server
CMD ["apache2-foreground"]
