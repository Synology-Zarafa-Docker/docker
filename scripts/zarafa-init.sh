#!/bin/bash
set -e

# TODO:
# - check for first boot
# - individual configuration

if [ ! -e /etc/zarafa-init-completed ]; then
	echo "This image has been started for the first time."
	echo
fi

case $1 in
stats)
	zarafa-stats --top
	;;
*)
	read
	exec "$@"
	;;
esac
