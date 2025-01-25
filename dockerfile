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

# Create the Apache configuration file in steps to avoid echo issues
RUN printf '<VirtualHost *:80>\n' > /etc/apache2/sites-available/000-default.conf
RUN printf 'DocumentRoot /var/www/smartchat\n' >> /etc/apache2/sites-available/000-default.conf
RUN printf '<Directory /var/www/smartchat>\n' >> /etc/apache2/sites-available/000-default.conf
RUN printf 'Options Indexes FollowSymLinks\n' >> /etc/apache2/sites-available/000-default.conf
RUN printf 'AllowOverride All\n' >> /etc/apache2/sites-available/000-default.conf
RUN printf 'Require all granted\n' >> /etc/apache2/sites-available/000-default.conf
RUN printf '</Directory>\n' >> /etc/apache2/sites-available/000-default.conf
RUN printf 'ErrorLog ${APACHE_LOG_DIR}/error.log\n' >> /etc/apache2/sites-available/000-default.conf
RUN printf 'CustomLog ${APACHE_LOG_DIR}/access.log combined\n' >> /etc/apache2/sites-available/000-default.conf
RUN printf '</VirtualHost>\n' >> /etc/apache2/sites-available/000-default.conf

# Start the Apache server
CMD ["apache2-foreground"]
