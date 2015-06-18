FROM ubuntu:trusty

RUN apt-get update && apt-get install -y wget

# Entry-Script
COPY /scripts/zarafa-init.sh /usr/local/bin/zarafa-init.sh

VOLUME ["/var/lib/mysql"]
VOLUME ["/var/lib/zarafa"]

# Expose Ports
EXPOSE 236 236
EXPOSE 237 237
EXPOSE 10080 80
EXPOSE 10443 443

# Set Entrypoint
ENTRYPOINT ["/usr/local/bin/zarafa-init.sh"]
