#!/bin/bash

case $1 in
update)
	echo "updating containers"
	docker pull percona:5.6
	docker pull fbartels/synology-zarafa
	docker pull fbartels/zarafa-webmeetings-docker
	;;
build)
	docker build -t fbartels/synology-zarafa .
	;;
stop)
	echo "stopping containers"
	docker stop zarafa-mysql
	docker stop synology-zarafa
	docker stop zarafa-webapp
	;;
start)
	$0 stop

	echo "creating data dirs"
	mkdir -p /volume1/docker/zarafa/{mysql,zarafalibs,z-push}

	echo "removing old containers (to reuse the assigned names)"
	docker rm zarafa-mysql
	docker rm synology-zarafa
	docker rm zarafa-webapp

	echo "starting mysql"
	docker run --name zarafa-mysql -e MYSQL_ROOT_PASSWORD=mysecretpassword \
	--volume /volume1/docker/zarafa/mysql:/var/lib/mysql -d percona:5.6
	echo "starting zarafa"
	docker run -d --name synology-zarafa --link zarafa-mysql:mysql --env-file=env.conf \
	--volume /volume1/docker/zarafa/zarafalibs:/var/lib/zarafa \
	-p 25:25 -p 236:236 -p 237:237 \
	fbartels/synology-zarafa
	echo "starting webapp/webmeetings"
	docker run --name zarafa-webapp --link synology-zarafa:webapp \
	-p 10080:10080 -p 10443:10443 -d \
	fbartels/zarafa-webmeetings-docker

	docker attach synology-zarafa
	;;
*)
	echo "Usage: $0 [start|stop|update|build]"
	;;
esac
