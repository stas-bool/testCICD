#!/bin/sh

ls /tmp/xdebug.log && chmod 766 /tmp/xdebug.log

# Решение проблемы с правами
USER=www-data
GROUP=www-data
cd /var/www/cicd/ && \
# В uid и gid записываем id владельца и его группы
uid=$(stat -c '%u' .)
gid=$(stat -c '%g' .)
# Меняем uid и gid пользователя www-data
usermod -u "$uid" $USER
groupmod -g "$gid" $GROUP
# Execute the CMD
exec "$@"