FROM serversideup/php:8.4-fpm-apache

# Switch to root so we can do root things
USER root

# Install the intl and bcmath extensions with root permissions
RUN install-php-extensions intl bcmath

RUN install-php-extensions imagick

# Drop back to our unprivileged user
USER www-data
