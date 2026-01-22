FROM serversideup/php:8.4-fpm-apache

# Przełącz na root, aby zainstalować pakiety
USER root

# Instalacja zależności systemowych (qpdf oraz git)
RUN apt-get update && apt-get install -y --no-install-recommends \
    qpdf \
    git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Instalacja rozszerzeń PHP (Composer jest już wbudowany w obraz bazowy)
RUN install-php-extensions intl bcmath imagick exif

# Powrót do użytkownika www-data
USER www-data
