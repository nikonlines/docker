#!/bin/bash

docker network create zabbix-net

#Create DB MySQL proxy
docker run -d -it --name "zabbix-proxy-mysql" \
--network "zabbix-net" --hostname "zabbix-proxy-mysql" -p 3307:3306 \
-v zabbix_proxy_mysql:/var/lib/mysql \
-e MYSQL_DATABASE="zabbix_proxy" -e MYSQL_USER="zabbix" -e MYSQL_PASSWORD="zabbix" \
-e MYSQL_ROOT_PASSWORD="root" \
mysql:latest \
--character-set-server=utf8 --collation-server=utf8_bin

#Create Zabbix-server-proxy
docker run -d -it --name "zabbix-server-proxy" \
--network "zabbix-net" --hostname "zabbix-proxy" -p 10052:10051 \
-v zabbix_proxy_snmptraps:/var/lib/zabbix/snmptraps \
-e DB_SERVER_HOST="zabbix-proxy-mysql" -e MYSQL_USER="zabbix" -e MYSQL_PASSWORD="zabbix" \
-e MYSQL_ROOT_PASSWORD="root" \
-e ZBX_SERVER_HOST="zabbix-server" \
-e ZBX_HOSTNAME="zabbix-proxy" \ #or IP-address
zabbix/zabbix-proxy-mysql
