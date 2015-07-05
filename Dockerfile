FROM fbartels/zarafa-base
MAINTAINER Felix Bartels "felix@host-consultants.de"

RUN apt-get install -y postfix postfix-ldap

RUN apt-get update && apt-get install --allow-unauthenticated --assume-yes \
	zarafa \
	zarafa-licensed

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
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/packages /root/webmeetings /etc/apt/sources.list.d/zarafa.list
