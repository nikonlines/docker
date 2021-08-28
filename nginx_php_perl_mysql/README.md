
# Container MYSQL
sudo docker run -d -i -t --restart always \\ \
--volume mysql_data:/var/lib/mysql \\ \
-p 3306:3306 \\ \
--env MYSQL_RANDOM_ROOT_PASSWORD=yes \\ \
--hostname mysql \\ \
--name mysql \\ \
mysql

# Container PHP-FPM
sudo docker run -d -i -t --restart always \\ \
--volume php-fpm_data:/usr/local/etc \\ \
--volume nginx_www:/usr/share/nginx \\ \
--workdir /usr/share/nginx/html \\ \
--link mysql \\ \
--hostname php-fpm \\ \
--name php-fpm \\ \
php:fpm

# Container FCGIWRAP (PERL)
sudo docker run -d -i -t --restart always \\ \
--volume fcgiwrap_lib:/usr/lib/cgi-bin \\ \
--link mysql \\ \
--hostname nginx-fcgiwrap \\ \
--name nginx-fcgiwrap \\ \
nginx-fcgiwrap # Make from Dockerfile

# Container NGINX
sudo docker run -d -i -t --restart always \\ \
--volume nginx_data:/etc/nginx \\ \
--volume nginx_www:/usr/share/nginx \\ \
--volume nginx_log:/var/log/nginx \\ \
--volume fcgiwrap_lib:/usr/lib/cgi-bin \\ \
-p 80:80 -p 443:443 \\ \
--link php-fpm \\ \
--link nginx-fcgiwrap \\ \
--hostname nginx \\ \
--name nginx \\ \
nginx

*******************************************

# Config for PHP-FPM
#Default dir: /usr/share/nginx/html \
location ~* \.php$ { \
  root   /usr/share/nginx/html; \
  fastcgi_pass php-fpm:9000; \
  fastcgi_index index.php; \
  try_files $uri $uri/ =404; \
  include fastcgi_params; \
  fastcgi_split_path_info ^(.+\.php)(/.+)$; \
  fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name; \
  fastcgi_param PATH_INFO $fastcgi_path_info; \
} 

# Config for FCGIWRAP (PERL) 
#Default dir: /usr/lib/cgi-bin/ \
location /cgi-bin/ { \
  gzip off; \
  root /usr/lib; \
  fastcgi_pass nginx-fcgiwrap:9090; \
  try_files $uri $uri/ =404; \
  include /etc/nginx/fastcgi_params; \
  fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name; \
}

# Config for .htaccess
location ~ /\.ht { \
  deny all; \
}

# serve static files directly
location ~* \.(jpg|jpeg|gif|css|png|js|ico|html)$ { \
  access_log off; \
  expires max; \
  log_not_found off; \
}
	
