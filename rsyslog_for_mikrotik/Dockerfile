FROM debian:latest

ARG DEBIAN_FRONTEND=noninteractive

ENV RSYSLOG_DIR="/var/log/rsyslog_remote"
#
ENV LOGROTATE_MODE="daily"
ENV LOGROTATE_COUNT="30"

RUN apt-get update -y && apt-get install -y rsyslog logrotate && \
#---------------
sed -i 's/module(load="imklog")/#module(load="imklog")/' /etc/rsyslog.conf && \
sed -i 's/#module(load="imudp")/module(load="imudp")/' /etc/rsyslog.conf && \
sed -i 's/#input(type="imudp" port="514")/input(type="imudp" port="514")/' /etc/rsyslog.conf && \
#---------------
echo "\$template RemoteLogs,\"${RSYSLOG_DIR}/%fromhost-ip%/%programname%.log\"" >> /etc/rsyslog.conf && \
echo "*.* ?RemoteLogs" >> /etc/rsyslog.conf && \
#---------------
echo -e "${RSYSLOG_DIR}/*/*.log\n\
{\n\
  rotate $LOGROTATE_COUNT\n\
  $LOGROTATE_MODE\n\
  compress\n\
  missingok\n\
  notifempty\n\
}" > /etc/logrotate.d/rsyslog_remote
#---------------

CMD service rsyslog restart && bash

VOLUME ${RSYSLOG_DIR}

EXPOSE 514/udp