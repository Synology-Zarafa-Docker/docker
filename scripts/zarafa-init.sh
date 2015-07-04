#!/bin/bash
set -e

# TODO:
# - check for first boot
# - individual configuration

if [ ! -e /etc/zarafa-init-completed ]; then
	echo "This image has been started for the first time."
	echo
	sed -i -e '/mysql_host/s/localhost/'${MYSQL_PORT_3306_TCP_ADDR}'/' /etc/zarafa/server.cfg
	# MYSQL_ENV_MYSQL_ROOT_PASSWORD
	echo "Initial Setup completed"
	touch /etc/zarafa-init-completed
fi

services="php5-fpm nginx zarafa-server"
for s in $services; do
	echo "starting $s"
	service $s start
done

case $1 in
stats)
	zarafa-stats --top
	;;
*)
	#/bin/bash
	exec "$@"
	;;
esac
