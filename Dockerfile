FROM php:8.3-fpm-alpine

# Instalar dependencias del sistema requeridas por Laravel, PostgreSQL y Frontend
RUN apk add --no-cache \
    bash \
    curl \
    git \
    icu-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libzip-dev \
    postgresql-dev \
    postgresql-client \
    oniguruma-dev \
    linux-headers \
    nodejs \
    npm

# Configurar e instalar extensiones de PHP necesarias (incluyendo PostgreSQL e Intl)
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        pdo_pgsql \
        pgsql \
        intl \
        zip \
        bcmath \
        exif \
        gd \
        opcache

# Instalar Composer oficial
COPY --from=composer:2.8 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copiar configuraciones personalizadas y normalizar saltos de línea LF
COPY docker/php/local.ini /usr/local/etc/php/conf.d/local.ini
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN sed -i 's/\r$//' /usr/local/bin/entrypoint.sh \
    && chmod +x /usr/local/bin/entrypoint.sh

# Copiar definiciones de dependencias de Composer primero
COPY composer.json composer.lock* /var/www/html/

# Instalar dependencias de producción de Composer
RUN composer install --no-dev --optimize-autoloader --no-scripts --no-interaction

# Copiar todo el código fuente de la aplicación (Frontend + Backend + Base de Datos)
COPY . /var/www/html

# Limpiar posibles cachés previas y regenerar autoload optimizado
RUN rm -f /var/www/html/bootstrap/cache/*.php \
    && composer dump-autoload --optimize --no-dev \
    && cp -a /var/www/html/vendor /opt/vendor_backup

# Respaldar assets compilados de Frontend para restaurarlos si el volumen host los oculta
RUN if [ -d /var/www/html/public/build ]; then cp -a /var/www/html/public/build /opt/build_backup; fi

# Permisos para storage, cache y base de datos interna
RUN mkdir -p /var/www/html/storage/framework/cache/data \
             /var/www/html/storage/framework/sessions \
             /var/www/html/storage/framework/views \
             /var/www/html/storage/logs \
             /var/www/html/bootstrap/cache \
             /var/www/html/database \
    && touch /var/www/html/database/database.sqlite \
    && chmod -R 777 /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/database

EXPOSE 9000 8080 80

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["php-fpm"]
