FROM serversideup/php:8.4-fpm-apache

# Switch to root so we can do root things
USER root

# Install system dependencies (QPDF)
RUN apt-get update && apt-get install -y qpdf  

# Install the intl and bcmath extensions with root permissions
RUN install-php-extensions intl bcmath imagick exif

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Drop back to our unprivileged user
USER www-data
