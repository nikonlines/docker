FROM debian:latest

ENV USER_LOGIN="admin"
ENV USER_PASSWORD="admin"
#
ENV ROOT_PASSWORD=""
ENV ROOT_SSH_ENABLE="false"

RUN apt-get update; \
    apt-get install -y sudo ssh vim nano mc git wget net-tools iputils-ping

WORKDIR /opt

COPY install_yate.sh .
RUN chmod 755 install_yate.sh && ./install_yate.sh

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

VOLUME ["/usr/local/share/yate"]
VOLUME ["/usr/local/etc/yate"]

EXPOSE 22/tcp
EXPOSE 80/tcp 5038/tcp
