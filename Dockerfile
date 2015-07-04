FROM ubuntu:trusty
MAINTAINER Felix Bartels "felix@host-consultants.de"

# Set the env variable DEBIAN_FRONTEND to noninteractive
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y
RUN apt-get install -y wget

# workaround to pam error: http://stackoverflow.com/q/25193161
#RUN ln -s -f /bin/true /usr/bin/chfn
#RUN apt-get install -y mysql-server-5.6

RUN apt-get install -y postfix postfix-ldap

RUN apt-get install -y nginx php5-fpm

# Downloading and installing Zarafa packages
RUN mkdir -p /root/packages \
	&& wget --no-check-certificate --quiet \
	https://download.zarafa.com/zarafa/drupal/download_platform.php?platform=beta/7.2/7.2.1-49597/zcp-7.2.1-49597-ubuntu-14.04-x86_64-forhome.tar.gz -O- \
	| tar xz -C /root/packages --strip-components=1

WORKDIR /root/packages

# Downloading WebApp packages
RUN wget --quiet -p -r -nc -nd -l 1 -e robots=off -A deb --no-check-certificate https://download.zarafa.com/community/final/WebApp/2.0.2/ubuntu-14.04/

# Packing everything into a local repository and installing it
RUN apt-ftparchive packages . | gzip -9c > Packages.gz && echo "deb file:/root/packages ./" > /etc/apt/sources.list.d/zarafa.list
RUN apt-get update && apt-get install --allow-unauthenticated --assume-yes \
	zarafa \
	zarafa-licensed \
	zarafa-webapp \
	zarafa-webapp-extbox \
	zarafa-webapp-files \
	zarafa-webapp-folderwidgets \
	zarafa-webapp-pdfbox \
	zarafa-webapp-titlecounter \
	zarafa-webapp-webappmanual

# Downloading and installing Z-Push
#RUN mkdir -p mkdir -p /usr/share/z-push \
#	&& wget --quiet http://download.z-push.org/beta/2.2/z-push-2.2.2beta-1972.tar.gz -O- \
#	| tar zx -C /usr/share/z-push/ --strip-components=1
#RUN mkdir -p /var/lib/z-push \
#	&& mkdir /var/log/z-push \
#	&& chown www-data:www-data /var/lib/z-push \
#	&& chown www-data:www-data /var/log/z-push
#RUN ln -s /usr/share/z-push/z-push-admin.php /usr/sbin/z-push-admin \
#	&& ln -s /usr/share/z-push/z-push-top.php /usr/sbin/z-push-top
#COPY /conf/logrotate-z-push /etc/logrotate.d/z-push
#COPY /conf/apache-z-push.conf /etc/apache2/sites-available/z-push.conf

# External mounts
VOLUME ["/etc/zarafa", "/var/lib/zarafa", "/var/lib/z-push"]

#Reset Workdir
WORKDIR /root

# Entry-Script
COPY /scripts/zarafa-init.sh /usr/local/bin/zarafa-init.sh

# Set Entrypoint
ENTRYPOINT ["/usr/local/bin/zarafa-init.sh"]
CMD ["stats"]

# cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN rm -rf /root/packages
