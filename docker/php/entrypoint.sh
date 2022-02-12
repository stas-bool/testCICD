#!/bin/sh

ls /tmp/xdebug.log && chmod 766 /tmp/xdebug.log

USER=www-data
GROUP=www-data
cd /var/www/cicd/ && \
uid=$(stat -c '%u' .)
gid=$(stat -c '%g' .)
usermod -u "$uid" $USER
groupmod -g "$gid" $GROUP
sudo -u $USER composer install | sudo tee -a composer.log
sudo -u $USER php yii migrate --interactive=0  | sudo tee -a migrate.log
# Execute the CMD
exec "$@"