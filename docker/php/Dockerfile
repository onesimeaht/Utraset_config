FROM php:8.3-fpm

# Install system deps + Node.js + outils utiles
RUN apt-get update && apt-get install -y \
    git curl zip unzip \
    libpng-dev libonig-dev libxml2-dev libpq-dev \
    nodejs npm \
    && docker-php-ext-install pdo pdo_pgsql pgsql mbstring exif pcntl bcmath gd

# Installer Redis (phpredis)
RUN pecl install redis \
    && docker-php-ext-enable redis

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Copier les fichiers
COPY . .

# Installer dépendances PHP
RUN composer install --optimize-autoloader --no-dev

# Build frontend (Vite)
RUN npm install && npm run build

# Permissions complètes Laravel (fix définitif)
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www/storage \
    && chmod -R 775 /var/www/bootstrap/cache

# Copier et rendre exécutable l'entrypoint
COPY docker/php/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER www-data

EXPOSE 9000

CMD ["/usr/local/bin/entrypoint.sh"]
