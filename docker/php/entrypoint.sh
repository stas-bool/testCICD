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
composer update && \
#composer install && \
php yii migrate --interactive=0
# Execute the CMD
exec "$@"