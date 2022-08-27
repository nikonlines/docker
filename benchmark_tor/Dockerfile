FROM debian:stretch

ARG DEBIAN_FRONTEND=noninteractive

ENV SITE_URL="https://<web_site>/"

#Example: "{ug},{us},{fr} StrictNodes1"
ENV TOR_ENTRYNODES=""   

#Example: "{ug},{us},{fr} StrictNodes1"
ENV TOR_EXITNODES=""

#
ENV NUMBER_REQUEST=1000000
ENV NUMBER_CONCURRENCY=1000
ENV USER_AGENT="User-Agent: *"

ENV CONTROL_PORT=9051

RUN apt-get update -y && \
    apt-get install -y apache2-utils curl tor tor-geoipdb torsocks && \
    apt-get clean autoclean; \
    apt-get autoremove --yes; \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

WORKDIR /opt

COPY start_script.sh .
RUN chmod +x start_script.sh

#VOLUME /log

ENTRYPOINT ["./start_script.sh"]
#CMD ["-r", "${NUMBER_REQUEST}", "-c", "${NUMBER_CONCURRENCY}", "-a", "${USER_AGENT}", "-s", "${SITE_URL}"]

EXPOSE $CONTROL_PORT
