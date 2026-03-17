FROM serversideup/php:8.4-fpm-apache

USER root

# Instalacja tylko niezbędnych pakietów systemowych
RUN apt-get update && apt-get install -y --no-install-recommends \
    qpdf \
    git \
    npm \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Aktualizacja Node.js
RUN npm install -g n && n stable

# Instalacja rozszerzeń PHP
RUN install-php-extensions intl bcmath imagick exif gd pcntl

USER www-data
