FROM serversideup/php:8.5-fpm-apache

# Switch to root so we can do root things
USER root

# Install system dependencies (QPDF)
RUN apt-get update && apt-get install -y qpdf  

# Install the intl and bcmath extensions with root permissions
RUN install-php-extensions intl bcmath

# Install imagick
RUN install-php-extensions imagick

# Install exif (WordPress media needs this)
RUN install-php-extensions exif

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Drop back to our unprivileged user
USER www-data
