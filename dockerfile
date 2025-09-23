# Mulai dari image dasar PHP 8.2 dengan Apache
FROM php:8.2-apache

# Set variabel lingkungan agar apt-get tidak menanyakan hal-hal interaktif
ENV DEBIAN_FRONTEND=noninteractive

# Install semua library sistem DAN composer
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libzip-dev \
    libicu-dev \
    libxml2-dev \
    libgd-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype-dev \
    libexif-dev \
    unzip \
    --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Composer (Manajer dependensi PHP)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Konfigurasi dan install ekstensi PHP yang dibutuhkan Moodle
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    pgsql \
    pdo_pgsql \
    zip \
    intl \
    soap \
    opcache \
    gd \
    exif