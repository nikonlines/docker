# Add to mikrotik

/system logging action add name="rsyslog" target=remote remote=<IPaddr_server_rsyslog> remote-port=1514 bsd-syslog=yes syslog-facility=daemon;

/system logging add topics=info action=rsyslog;
/system logging add topics=error action=rsyslog;
/system logging add topics=warning action=rsyslog;
/system logging add topics=critical action=rsyslog;

#-----------------------------

#Create docker image
sudo docker build . --no-cache --compress --tag rsyslog_remote

#Create docker container
sudo docker run -d -i -t --restart always \
-v rsyslog_log:/var/log/rsyslog_remote \
-p 1514:514/udp \
--hostname rsyslog \
--name rsyslog_remote \
rsyslog_remote

