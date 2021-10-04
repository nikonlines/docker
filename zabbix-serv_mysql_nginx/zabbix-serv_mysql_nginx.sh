#!/bin/bash

docker network create zabbix-net

#Create DB MySQL
docker run -d -it --name "zabbix-mysql" \
--network "zabbix-net" --hostname "zabbix-mysql" -p 3306:3306 \
-v zabbix_mysql:/var/lib/mysql \
-e MYSQL_DATABASE="zabbix" -e MYSQL_USER="zabbix" -e MYSQL_PASSWORD="zabbix" \
-e MYSQL_ROOT_PASSWORD="root" \
mysql:latest \
--character-set-server=utf8 --collation-server=utf8_bin


#Create Zabbix-server
docker run -d -it --name "zabbix-server-mysql" \
--network "zabbix-net" --hostname "zabbix-server" -p 10051:10051 \
-v zabbix_export:/var/lib/zabbix/export \
-v zabbix_snmptraps:/var/lib/zabbix/snmptraps \
-e DB_SERVER_HOST="zabbix-mysql" -e MYSQL_USER="zabbix" -e MYSQL_PASSWORD="zabbix" \
-e MYSQL_ROOT_PASSWORD="root" \
zabbix/zabbix-server-mysql:latest

#Create Web-server
docker run -d -it --name "zabbix-web-nginx-mysql" \
--network "zabbix-net" --hostname "zabbix-web" -p 8888:8080 -p 8443:443 \
-e DB_SERVER_HOST="zabbix-mysql" -e MYSQL_USER="zabbix" -e MYSQL_PASSWORD="zabbix" \
-e ZBX_SERVER_HOST="zabbix-server" -e PHP_TZ="Europe/Kiev" \
zabbix/zabbix-web-nginx-mysql
