#!/bin/bash

docker network create zabbix-net

#Create DB PostgreSQL
docker run -d -it --name "zabbix-pgsql" \
--network "zabbix-net" --hostname "zabbix-pgsql" -p 5432:5432 \
-v postgresql_data:/var/lib/postgresql/data \
-e POSTGRES_DB="zabbix" \
-e POSTGRES_USER="zabbix" \
-e POSTGRES_PASSWORD="zabbix" \
postgres:latest

#Create Zabbix-server
docker run -d -it --name "zabbix-server-pgsql" \
--network "zabbix-net" --hostname "zabbix-server" -p 10051:10051 \
-v zabbix_export:/var/lib/zabbix/export \
-v zabbix_snmptraps:/var/lib/zabbix/snmptraps \
-e DB_SERVER_HOST="zabbix-pgsql" \
-e POSTGRES_DB="zabbix" -e POSTGRES_USER="zabbix" -e POSTGRES_PASSWORD="zabbix" \
zabbix/zabbix-server-pgsql:latest

#Create Web-server
docker run -d -it --name "zabbix-web-nginx-pgsql" \
--network "zabbix-net" --hostname "zabbix-web" -p 8888:8080 -p 8443:443 \
-e DB_SERVER_HOST="zabbix-pgsql" \
-e POSTGRES_DB="zabbix" -e POSTGRES_USER="zabbix" -e POSTGRES_PASSWORD="zabbix" \
-e ZBX_SERVER_HOST="zabbix-server" -e PHP_TZ="Europe/Kiev" \
zabbix/zabbix-web-nginx-pgsql:latest

