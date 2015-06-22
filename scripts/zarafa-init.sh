#!/bin/bash
set -e

# TODO:
# - check for first boot
# - individual configuration

if [ ! -e /etc/zarafa-init-completed ]; then
	echo "This image has been started for the first time."
	echo
	echo "Initial Setup completed"
	touch /etc/zarafa-init-completed
fi

services="cron php5-fpm nginx"
for s in $services; do
	echo "starting $s"
	service $s start
done

case $1 in
stats)
	zarafa-stats --top
	;;
*)
	/bin/bash
	#exec "$@"
	;;
esac
