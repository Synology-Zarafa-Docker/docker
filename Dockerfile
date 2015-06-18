FROM ubuntu:trusty
MAINTAINER Felix Bartels "felix@host-consultants.de"

# Set the env variable DEBIAN_FRONTEND to noninteractive
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y wget

# Entry-Script
COPY /scripts/zarafa-init.sh /usr/local/bin/zarafa-init.sh

RUN mkdir -p /root/packages \
	&& wget --no-check-certificate --quiet \
	http://download.zarafa.com/zarafa/drupal/download_platform.php?platform=beta/7.2/7.2.1-49597/zcp-7.2.1-49597-ubuntu-14.04-x86_64-forhome.tar.gz -O- \
	| tar xz -C /root/packages --strip-components=1

WORKDIR /root/packages

RUN wget --quiet -p -r -nc -nd -l 1 -e robots=off -A deb --no-check-certificate https://download.zarafa.com/community/final/WebApp/2.0.2/ubuntu-14.04/

RUN apt-ftparchive packages . | gzip -9c > Packages.gz && echo "deb file:/root/packages ./" > /etc/apt/sources.list.d/zarafa.list

RUN apt-get update && apt-get install --allow-unauthenticated --assume-yes \
	zarafa \
	zarafa-webapp \
	zarafa-webapp-extbox \
	zarafa-webapp-files \
	zarafa-webapp-folderwidgets \
	zarafa-webapp-pdfbox \
	zarafa-webapp-titlecounter \
	zarafa-webapp-webappmanual

VOLUME ["/var/lib/mysql"]
VOLUME ["/var/lib/zarafa"]

# Expose Ports
EXPOSE 236 236
EXPOSE 237 237
EXPOSE 10080 80
EXPOSE 10443 443

#Reset Workdir
WORKDIR /root

# Set Entrypoint
ENTRYPOINT ["/usr/local/bin/zarafa-init.sh"]
