FROM ubuntu:trusty

# Set the env variable DEBIAN_FRONTEND to noninteractive
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y curl

# Entry-Script
COPY /scripts/zarafa-init.sh /usr/local/bin/zarafa-init.sh

RUN mkdir -p /root/packages \
	&& curl -SL http://download.zarafa.com/zarafa/drupal/download_platform.php?platform=beta/7.2/7.2.1-49597/zcp-7.2.1-49597-ubuntu-14.04-x86_64-forhome.tar.gz \
	| tar xz -C /root/packages --strip-components=1    

VOLUME ["/var/lib/mysql"]
VOLUME ["/var/lib/zarafa"]

# Expose Ports
EXPOSE 236 236
EXPOSE 237 237
EXPOSE 10080 80
EXPOSE 10443 443

# Set Entrypoint
ENTRYPOINT ["/usr/local/bin/zarafa-init.sh"]
