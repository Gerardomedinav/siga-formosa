# --- Dockerfile Optimizado para Render (SIGA - UTN) ---
FROM php:8.3-fpm-alpine

# 1. Instalar dependencias del sistema y extensiones de PHP necesarias
RUN apk update && apk add --no-cache \
    git \
    openssl \
    curl \
    postgresql-dev \
    nodejs \
    npm \
    make \
    g++ \
    && docker-php-ext-install pdo_pgsql opcache pcntl exif \
    && rm -rf /var/cache/apk/*

# 2. Instalar Composer globalmente
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# 3. Establecer directorio de trabajo
WORKDIR /var/www

# 4. Copiar los archivos del proyecto al contenedor
COPY . .

# 5. Instalar dependencias de PHP (Composer)
# Nota: Ignoramos dependencias de desarrollo y optimizamos el autoloader
RUN composer install --prefer-dist --no-dev --optimize-autoloader

# 6. Instalar dependencias de Node y compilar assets (Vite)
RUN npm install
RUN npm run build

# --- NOTA IMPORTANTE ---
# Hemos eliminado 'cp .env.example .env' y 'key:generate' 
# para que Laravel use las variables que configuraste en el panel de Render.
# -----------------------

# 7. Configurar permisos para carpetas de almacenamiento y caché
RUN chown -R www-data:www-data /var/www/storage \
    && chmod -R 775 /var/www/storage

# 8. Exponer el puerto que usará php artisan serve
EXPOSE 8000

# -----------------------------------------------------------
# 9. SCRIPT DE INICIO (Ejecutado al arrancar el contenedor)
# -----------------------------------------------------------
RUN printf "#!/bin/sh\n\
set -e\n\
\n\
echo '🚀 Iniciando limpieza y preparación...'\n\
php artisan config:clear\n\
php artisan cache:clear\n\
\n\
echo '🔗 Creando enlace simbólico de almacenamiento...'\n\
php artisan storage:link --force\n\
\n\
echo '📦 Sincronizando Base de Datos PostgreSQL...'\n\
# --force es obligatorio en producción\n\
php artisan migrate --force\n\
\n\
echo '🌱 Actualizando usuario administrador (UsersSeeder)...'\n\
php artisan db:seed --class=UsersSeeder --force\n\
\n\
echo '📝 Generando caché de producción para alta velocidad...'\n\
php artisan config:cache\n\
php artisan route:cache\n\
php artisan view:cache\n\
\n\
echo '🔥 Servidor SIGA Online en puerto 8000'\n\
exec php artisan serve --host=0.0.0.0 --port=8000\n\
" > /usr/local/bin/start-container

# Hacer el script ejecutable
RUN chmod +x /usr/local/bin/start-container

# 10. Comando final para arrancar la aplicación
CMD ["/usr/local/bin/start-container"]