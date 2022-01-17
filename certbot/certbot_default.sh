#!/bin/bash

#CertBot container
sudo docker run -it --name "certbot" \
-v "/etc/letsencrypt:/etc/letsencrypt" \
-v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
certbot/certbot certonly
