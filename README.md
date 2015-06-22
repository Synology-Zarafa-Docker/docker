# Docker Image to easily run Zarafa on a Synology Diskstation
Future home of a Zarafa Docker image tailored for Synology.

WARNING! This is still a work in progress and not yet ready for actual use!

## Installation
This image can easily be pulled from the Docker Hub:

```
docker pull fbartels/synology-zarafa
```

## Usage

```
docker run --env-file=env.conf \
--volume /volume1/docker/zarafa/mysql:/var/lib/mysql \
--volume /volume1/docker/zarafa/zarafalibs:/var/lib/zarafa \
--volume /volume1/docker/zarafa/z-push:/var/lib/z-push \
--name zarafa -d fbartels/synology-zarafa
```
