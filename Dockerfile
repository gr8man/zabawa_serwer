# Krok 1: Pobranie lekkiego obrazu Node.js (wersja LTS)
FROM node:22-slim AS node

# Krok 2: Właściwy obraz
FROM serversideup/php:8.4-fpm-apache

USER root

# Kopiowanie czystego Node.js i NPM omijając ciężką instalację z apt
COPY --from=node /usr/local/bin/node /usr/local/bin/
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules/
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
 && ln -s /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx

# Instalacja tylko niezbędnych pakietów systemowych
RUN apt-get update && apt-get install -y --no-install-recommends \
    qpdf \
    git \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Instalacja rozszerzeń PHP
RUN install-php-extensions intl bcmath imagick exif gd pcntl

USER www-data
