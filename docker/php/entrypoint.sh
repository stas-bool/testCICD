#!/bin/sh
# Start the SSH server
if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
	ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
fi
if [ ! -f "/etc/ssh/ssh_host_dsa_key" ]; then
	ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa
fi
/usr/sbin/sshd -f /etc/ssh/sshd_config

ls /tmp/xdebug.log && chmod 766 /tmp/xdebug.log

cd /var/www/cicd/ && \
chown -R www-data:www-data . && \
find /var/www/ -type f -exec chmod 664 {} + && \
find /var/www/ -type d -exec chmod 775 {} + && \
composer install || composer update && \
php yii migrate --interactive=0
# Execute the CMD
exec "$@"