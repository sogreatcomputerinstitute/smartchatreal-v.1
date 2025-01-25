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

# Create the Apache configuration file using a here-document
RUN cat <<EOT > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
    DocumentRoot /var/www/smartchat
    <Directory /var/www/smartchat>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    DirectoryIndex welcome.php
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOT

# Start the Apache server
CMD ["apache2-foreground"]
