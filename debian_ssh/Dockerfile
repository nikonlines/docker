FROM debian:latest

ENV USER_LOGIN="admin"
ENV USER_PASSWORD="admin"
#
ENV ROOT_PASSWORD=""
ENV ROOT_SSH_ENABLE="false"
#
ENV ETC_DIR="/etc"
ENV HOME_DIR="/home"
ENV OPT_DIR="/opt"

RUN apt-get update; \
    apt-get install -y sudo ssh vim nano mc git wget net-tools iputils-ping

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

VOLUME [ "${ETC_DIR}" ]
VOLUME [ "${HOME_DIR}" ]
VOLUME [ "${OPT_DIR}" ]

EXPOSE 22/tcp
