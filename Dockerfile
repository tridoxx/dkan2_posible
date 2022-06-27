ARG BASE_IMAGE=php:7.4-fpm-alpine

# PHP Dependency install via Composer.
# Build the Docker image for Drupal.
FROM $BASE_IMAGE as build

WORKDIR '/app/data'

# Add Drush and Composer and php libs.
RUN curl -OL https://github.com/drush-ops/drush-launcher/releases/latest/download/drush.phar \
 && chmod +x drush.phar \
 && mv drush.phar /usr/local/bin/drush \
 && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer \
 && apk add --no-cache git patch mysql-client libpng libpng-dev nodejs npm libzip-dev \
 && docker-php-ext-install zip opcache mysqli pdo pdo_mysql \
 && apk add --no-cache freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev && \
   docker-php-ext-configure gd \
     --with-freetype \
     --with-jpeg \
   NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
   docker-php-ext-install -j$(nproc) gd && \
   apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev \
 && docker-php-ext-enable pdo_mysql

# Copy composer files to image
COPY composer.json composer.lock ./

# Only copy custom modules in prod / mounted volume in dev

COPY config/ ./config
COPY src/ ./src
COPY scripts/* ./

#RUN cd docroot/sites/default/ && rm -rf settings.*.php
RUN mkdir -p docroot/sites docroot/libraries


# WORKDIR '/app/data'
RUN git clone -b cgn https://github.com/markaspot/data-catalog-app.git src/frontend

RUN ln -s ../../src/site docroot/sites/default
RUN ln -s ../src/frontend/ docroot/frontend



####
## Copy settings for production
####
FROM build as development
COPY conf/settings.docker.php ./src/site

####
## Copy settings for production
####
FROM build as production
COPY conf/settings.prod.php ./src/site

