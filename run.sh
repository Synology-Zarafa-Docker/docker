#!/bin/bash
echo "stopping older containers"
docker stop zarafa-mysql
docker stop synology-zarafa

echo "removing old containers (to reuse the assigned names)"
docker rm zarafa-mysql
docker rm synology-zarafa
#docker rm zarafa-webmeetings-docker

docker build -t fbartels/synology-zarafa .

echo "creating data dirs"
mkdir -p /volume1/docker/zarafa/{mysql,zarafalibs,z-push}

echo "starting mysql"
docker run --name zarafa-mysql -e MYSQL_ROOT_PASSWORD=mysecretpassword -d percona:5.6
echo "starting zarafa"
docker run --name synology-zarafa --link zarafa-mysql:mysql -it --env-file=env.conf \
--volume /volume1/docker/zarafa/zarafalibs:/var/lib/zarafa \
-p 25:25 -p 236:236 -p 237:237 \
fbartels/synology-zarafa bash
