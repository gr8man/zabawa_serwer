FROM serversideup/php:8.4-fpm-apache

# Przełącz na root, aby zainstalować pakiety
USER root

# Instalacja zależności systemowych
RUN apt-get update && apt-get install -y --no-install-recommends \
    qpdf \
    git \
    npm \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Aktualizacja Node.js
RUN npm install -g n && n stable

# Instalacja rozszerzeń PHP (Dodano 'gd')
RUN install-php-extensions intl bcmath imagick exif gd

# Powrót do użytkownika www-data
USER www-data
