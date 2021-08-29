#!/bin/bash

# Container MYSQL
sudo docker run -d -i -t --restart always \
--volume mysql_data:/var/lib/mysql \
-p 3306:3306 \
--env MYSQL_RANDOM_ROOT_PASSWORD=yes \
--hostname mysql \
--name mysql \
mysql

# Container PHP-FPM
sudo docker run -d -i -t --restart always \
--volume php-fpm_data:/usr/local/etc \
--volume nginx_www:/usr/share/nginx \
--workdir /usr/share/nginx/html \
--link mysql \
--hostname php-fpm \
--name php-fpm \
php:fpm

# Container FCGIWRAP (PERL)
sudo docker run -d -i -t --restart always \
--volume fcgiwrap_lib:/usr/lib/cgi-bin \
--link mysql \
--hostname nginx-fcgiwrap \
--name nginx-fcgiwrap \
nginx-fcgiwrap # Make from Dockerfile

# Container NGINX
sudo docker run -d -i -t --restart always \
--volume nginx_data:/etc/nginx \
--volume nginx_www:/usr/share/nginx \
--volume nginx_log:/var/log/nginx \
--volume fcgiwrap_lib:/usr/lib/cgi-bin \
--volume nginx_certs:/etc/letsencrypt \
-p 80:80 -p 443:443 \
--link php-fpm \
--link nginx-fcgiwrap \
--hostname nginx \
--name nginx \
nginx
	
	
