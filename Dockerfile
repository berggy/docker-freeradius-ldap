FROM alpine:3.13.1

MAINTAINER 2stacks <2stacks@2stacks.net>

# Use docker build --pull -t 2stacks/freeradius-ldap .

# Image details--changed by berg for LDAP
LABEL net.2stacks.name="2stacks" \
      net.2stacks.license="MIT" \
      net.2stacks.description="Dockerfile for autobuilds" \
      net.2stacks.url="http://www.2stacks.net" \
      net.2stacks.vcs-type="Git" \
      net.2stacks.version="1.5.1" \
      net.2stacks.radius.version="3.0.20-r1"

RUN apk --update add freeradius freeradius-mysql freeradius-eap openssl freeradius-utils freeradius-ldap mysql-client

EXPOSE 1812/udp 1813/udp

ENV DB_HOST=localhost
ENV DB_PORT=3306
ENV DB_USER=radius
ENV DB_PASS=radpass
ENV DB_NAME=radius
ENV RADIUS_KEY=testing123
ENV RAD_CLIENTS=10.0.0.0/24
ENV RAD_DEBUG=no

ENV LDAP_SERVER=localhost
ENV LDAP_PORT=389
ENV LDAP_ADMIN=admin
ENV LDAP_ADMIN_PASSWD=password
ENV LDAP_BASE_DN=basedn

ADD --chown=root:radius ./etc/raddb/ /etc/raddb
RUN /etc/raddb/certs/bootstrap && \
    chown -R root:radius /etc/raddb/certs && \
    chmod 640 /etc/raddb/certs/*.pem


ADD ./scripts/start.sh /start.sh
ADD ./scripts/wait-for.sh /wait-for.sh

RUN chmod +x /start.sh wait-for.sh

VOLUME ["/etc/raddb/mods-available","/etc/raddb/mods-enabled"]

CMD ["/start.sh"]
