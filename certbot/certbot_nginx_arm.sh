#!/bin/bash

#CertBot container
docker run -d -it --name "certbot_nginx" \
--hostname "certbot_nginx" \
-v "letsencrypt_data:/etc/letsencrypt" \
-v "letsencrypt_lib:/var/lib/letsencrypt" \
-v "certbot_www:/var/www/certbot" \
certbot/certbot:arm32v6-latest \
'certonly --force-renewal --email <username>@<hostname>.<domain> --webroot -w /var/www/certbot -d <sub_domain>.<hostname>.<domain>'

#NGINX container
docker run -d -it --name "nginx" \
--hostname "nginx" -p 80:80 -p 443:443 \
-v "nginx_data:/etc/nginx" \
-v "nginx_www:/usr/share/nginx/html" \
-v "nginx_log:/var/log/nginx" \
-v "letsencrypt_data/etc/letsencrypt" \
-v "certbot_www:/var/www/certbot" \
nginx:latest
