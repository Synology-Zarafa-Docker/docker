#!/bin/bash
set -e

# TODO:
# - check for first boot
# - individual configuration

if [ ! -e /etc/zarafa-init-completed ]; then
	echo "This image has been started for the first time."
	echo
	sed -i -e '/mysql_host/s/localhost/'${MYSQL_PORT_3306_TCP_ADDR}'/' /etc/zarafa/server.cfg
	sed -i -e '/mysql_password/s/=/= '${MYSQL_ENV_MYSQL_ROOT_PASSWORD}'/' /etc/zarafa/server.cfg
	echo "Initial Setup completed"
	touch /etc/zarafa-init-completed
fi

# wait for mysql
until $(nc -z -w5 ${MYSQL_PORT_3306_TCP_ADDR} 3306); do
	echo "Waiting for MySQL to become available"
        sleep 1
done

services="zarafa-licensed zarafa-server"
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

