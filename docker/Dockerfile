# Base image with PHP-FPM
FROM php:8.2-fpm

# Install Nginx
RUN apt-get update && apt-get install -y nginx

# Copy your app
COPY ./app /var/www/html

# Copy nginx configuration
COPY ./docker/nginx.conf /etc/nginx/sites-available/default

# Expose ports (Cloud Run uses 8080)
EXPOSE 8080

# Use a process manager to run both PHP-FPM and Nginx
CMD ["sh", "-c", "php-fpm -D && nginx -g 'daemon off;'"]