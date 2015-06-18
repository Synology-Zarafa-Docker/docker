#!/bin/bash

DOWNLOAD_BASE="http://download.zarafa.com/supported/final/7.2"
USER=
PASSWORD=
WGETCMD="wget --user=$USER --password=$PASSWORD --no-check-certificate"
VERSION=$($WGETCMD --quiet $DOWNLOAD_BASE -O- | cut -d">" -f7 | grep "\." | grep -v final | rev | cut -c5-16 | rev| tail -1)
REPODIR=/root/zarafa-packages
mkdir -p $REPODIR

echo "Downloading Zarafa $VERSION"
$WGETCMD $DOWNLOAD_BASE/$VERSION/zcp-$VERSION-ubuntu-14.04-x86_64-forhome.tar.gz -O- | tar xz -C $REPODIR --strip-components=1

cd $REPODIR
apt-ftparchives packages . | gzip -9c > .Packages.gz

echo "deb file:$REPODIR ./" > /etc/apt/sources.list.d/zarafa.list
apt-get update
apt-get install --allow-unauthenticated --assume-yes zarafa
