Создаем docker-образ "nginx-fcgiwrap" с Dockerfile

> sudo docker build . --no-cache --compress --tag nginx-fcgiwrap

Создаем и запускаем контейнер на основе docker-образа "nginx-fcgiwrap"

> sudo docker run -d -i -t --restart always \\ \
> -v fcgiwrap_lib:/usr/lib/cgi-bin \\ \
> -p 9090:9090 \\ \
> --name nginx-fcgiwrap \\ \
> nginx-fcgiwrap

************************************************

К примеру создаем и запускаем контейнер на основе docker-образа "nginx"

> sudo docker run -d -i -t --restart always \\ \
> -v nginx_data:/etc/nginx \\ \
> -v nginx_www:/usr/share/nginx \\ \
> -v nginx_log:/var/log/nginx \\ \
> -v fcgiwrap_lib:/usr/lib/cgi-bin \\ \
> -p 80:80 -p 443:443 \\ \
> --name nginx \\ \
> nginx

Добавляем в файл конфигурации сайта (например в default.conf):

> nano /etc/nginx/conf.d/default.conf

строки в "server { ... }":

> location /cgi-bin/ { \
>   #Disable gzip (it makes scripts feel slower since they have to complete \
>   #before getting gzipped) \
>   gzip off;
>  
>   #Set the root to /usr/lib (inside this location this means that we are \
>   #giving access to the files under /usr/lib/cgi-bin \
>   root /usr/lib;
>  
>   #Fastcgi socket \
>   fastcgi_pass <ip_fcgiwrap_container>:9090;
>  
>   #Fastcgi parameters, include the standard ones \
>   include /etc/nginx/fastcgi_params;
>  
>   #Adjust non standard parameters (SCRIPT_FILENAME) \
>   fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name; \
> }

Для теста копируем файл "index.pl" в каталог "/usr/lib/cgi-bin/"

