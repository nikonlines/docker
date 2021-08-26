FROM debian:latest

ENV FCGI_PORT="9090"
ENV FCGI_ROOT="/usr/lib/cgi-bin"

RUN apt-get update \
    && apt-get install -y fcgiwrap perl libdbd-mysql-perl \
	&& rm -rf /var/lib/{apt,dpkg,cache,log}/

CMD fcgiwrap -s tcp:0.0.0.0:${FCGI_PORT}

VOLUME [ "${FCGI_ROOT}" ]
