# --- Dockerfile Optimizado para Render ---
FROM php:8.3-fpm-alpine

# 1. Instalar dependencias
RUN apk update && apk add --no-cache \
    git openssl curl postgresql-dev nodejs npm make g++ \
    && docker-php-ext-install pdo_pgsql opcache pcntl exif \
    && rm -rf /var/cache/apk/*

# 2. Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www
COPY . .

# 3. Instalar dependencias (Sin generar .env)
RUN composer install --prefer-dist --no-dev --optimize-autoloader
RUN npm install && npm run build

# 4. Permisos
RUN chown -R www-data:www-data /var/www/storage \
    && chmod -R 775 /var/www/storage

EXPOSE 8000

# 5. SCRIPT DE INICIO
RUN printf "#!/bin/sh\n\
set -e\n\
\n\
echo '🧹 Limpiando configuraciones previas...'\n\
php artisan config:clear\n\
php artisan cache:clear\n\
\n\
echo '🔗 Enlace de almacenamiento...'\n\
php artisan storage:link --force\n\
\n\
echo '📦 Migraciones y Seeders (Forzando actualización)...'\n\
# Usamos migrate:fresh solo si puedes permitirte borrar datos para asegurar limpieza total\n\
# Si tienes datos reales, usa solo migrate --force\n\
php artisan migrate --force\n\
php artisan db:seed --force\n\
\n\
echo '📝 Optimizando...'\n\
php artisan config:cache\n\
php artisan route:cache\n\
php artisan view:cache\n\
\n\
echo '🔥 Iniciando servidor...'\n\
exec php artisan serve --host=0.0.0.0 --port=8000\n\
" > /usr/local/bin/start-container

RUN chmod +x /usr/local/bin/start-container
CMD ["/usr/local/bin/start-container"]