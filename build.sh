#!/bin/bash

sudo docker build -t fbartels/synology-zarafa .

echo
read -p "Run this build?? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
	sudo mkdir -p /volume1/docker/zarafa/{mysql,zarafalibs,z-push}
	sudo docker run -it --env-file=env.conf \
	--volume /volume1/docker/zarafa/mysql:/var/lib/mysql \
	--volume /volume1/docker/zarafa/zarafalibs:/var/lib/zarafa \
	--volume /volume1/docker/zarafa/z-push:/var/lib/z-push \
	-p 25:25 -p 236:236 -p 237:237 -p 10080:80 -p 10443:443 \
	-d fbartels/synology-zarafa /bin/bash
fi
