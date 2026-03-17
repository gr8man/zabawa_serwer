# ==========================================
# ETAP 1: Kompilacja MassDNS
# ==========================================
FROM debian:bookworm-slim AS massdns-builder
# Instalujemy kompilator tylko w tej tymczasowej warstwie
RUN apt-get update && apt-get install -y git make gcc libc6-dev
# Pobieramy i kompilujemy massdns
RUN git clone https://github.com/blechschmidt/massdns.git /massdns \
    && cd /massdns \
    && make

# ==========================================
# ETAP 2: Pobranie Node.js
# ==========================================
FROM node:22-slim AS node

# ==========================================
# ETAP 3: Docelowy obraz serwera WWW
# ==========================================
FROM serversideup/php:8.3-fpm-apache

USER root

# 1. Skopiowanie Node.js (z etapu 2)
COPY --from=node /usr/local/bin/node /usr/local/bin/
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules/
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
 && ln -s /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx

# 2. Skopiowanie gotowego MassDNS (z etapu 1)
COPY --from=massdns-builder /massdns/bin/massdns /usr/local/bin/massdns

# 3. Instalacja pakietów systemowych i przydatnych narzędzi (itp.)
# Dodano curl, jq (do JSON) oraz bind9-dnsutils (narzędzie 'dig') do debugowania sieci
RUN apt-get update && apt-get install -y --no-install-recommends \
    qpdf \
    git \
    curl \
    jq \
    bind9-dnsutils \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# 4. Instalacja rozszerzeń PHP
RUN install-php-extensions intl bcmath imagick exif gd pcntl

USER www-data
