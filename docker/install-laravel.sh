#!/bin/sh

# Install Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
php -r "unlink('composer-setup.php');"

# Create new Laravel project
composer create-project laravel/laravel /app

# Set permissions
chown -R www-data:www-data /app
chmod -R 775 /app/storage /app/bootstrap/cache

# Install dependencies
cd /app
composer install

# Generate application key
php artisan key:generate

# Configure environment
sed -i 's/DB_DATABASE=laravel/DB_DATABASE=laravel/' .env
sed -i 's/DB_USERNAME=root/DB_USERNAME=laravel/' .env
sed -i 's/DB_PASSWORD=/DB_PASSWORD=laravel/' .env

# Configure Redis
sed -i 's/REDIS_HOST=127.0.0.1/REDIS_HOST=redis/' .env

# Configure Mail
sed -i 's/MAIL_HOST=mailpit/MAIL_HOST=mailhog/' .env
sed -i 's/MAIL_PORT=1025/MAIL_PORT=1025/' .env 