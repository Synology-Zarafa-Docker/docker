#!/bin/bash
set -e

# TODO:
# - check for first boot
# - ask credentials for portal.zarafa.com
# - download zarafa home packages
# - install them
# - update functionality?

DOWNLOAD_BASE="http://download.zarafa.com/supported/final/7.2"
WGETCMD="wget --user=$USER --password=$PASSWORD --no-check-certificate"
VERSION=$($WGETCMD --quiet $DOWNLOAD_BASE -O- | cut -d">" -f7 | grep "\." | grep -v final | rev | cut -c5-16 | rev| tail -1)
REPODIR=/root/zarafa-packages
mkdir -p $REPODIR

function get_portal_credentials() {
	echo "Please enter your credentials:"
	read -p "Username: " USER
	echo "USER=$USER" > /etc/zarafa-init-completed
	read -p "Password: " PASSWORD
	echo "PASSWORD=$PASSWORD" >> /etc/zarafa-init-completed
}

function test_portal_credentials() {
	export VERSION=$($WGETCMD --quiet $DOWNLOAD_BASE -O- | cut -d">" -f7 | grep "\." | grep -v final | rev | cut -c5-16 | rev| tail -1)
	if [ ! $? -eq 0 ]; then
		echo "Your credentials seem were not correct"
		get_portal_credentials
	else
		echo "The current Zarafa version is: $VERSION
	fi
}

if [ ! -e /etc/zarafa-init-completed ]; then
	echo "This image has been started for the first time."
	echo "To download the Zarafa for Home packages your credentials for http://portal.zarafa.com are needed."
	echo "If you don't already have an account you can create one on the following page: https://portal.zarafa.com/user/register."
	echo
	get_portal_credentials
	test_portal_credentials
fi

case $1 in
stats)
	zarafa-stats --top
	;;
*)
	exec "$@"
	;;
esac
