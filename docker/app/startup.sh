#!/bin/bash
set -e
# 1. Sync the Laravel boilerplate to the host volume if the host is empty
if [ ! -f "/var/www/artisan" ]; then
    echo "First run detected! Copying Laravel boilerplate to host volume..."
    cp -rn /var/www_tmp/* /var/www/
    cp -rn /var/www_tmp/.[!.]* /var/www/ 2>/dev/null || true
    
    # Optional overlay: If you had local host overrides (like custom controllers), 
    # they would have been safely kept because of the -n (no clobber) flag!
fi
# 2. Proceed with database wait
echo "Waiting for database..."
until (echo > /dev/tcp/mysql/3306) &>/dev/null; do
    sleep 2
done
echo "Database is ready."
# 3. Handle Breeze and Migrations
if [ ! -f "/var/www/app/Http/Controllers/Auth/AuthenticatedSessionController.php" ]; then
    php artisan breeze:install blade --dark --pest --no-interaction
    npm install && npm run build
fi

if [ ! -f "/var/www/public/build/manifest.json" ]; then
    echo "Vite manifest missing! Rebuilding frontend assets..."
    npm install && npm run build
fi
php artisan migrate
php-fpm