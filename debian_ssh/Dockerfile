FROM debian:latest

ENV USER_LOGIN="admin"
ENV USER_PASSWORD="admin"
#
ENV ROOT_PASSWORD=""
ENV ROOT_SSH_ENABLE="false"

RUN apt-get update; \
    apt-get install -y sudo ssh vim nano mc git wget net-tools iputils-ping

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 22/tcp
