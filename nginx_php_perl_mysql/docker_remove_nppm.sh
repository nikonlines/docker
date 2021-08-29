#!/bin/bash

#Stop and remove containers
sudo docker stop nginx
sudo docker rm nginx

sudo docker stop nginx-fcgiwrap
sudo docker rm nginx-fcgiwrap

sudo docker stop php-fpm
sudo docker rm php-fpm

sudo docker stop mysql
sudo docker rm mysql

#Remove volumes
sudo docker volume rm php-fpm_data
