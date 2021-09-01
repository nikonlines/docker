

> sudo chmod 755 entrypoint.sh

Make docker-image YateBTS
> sudo docker build . --no-cache --compress --tag yatebts

Create container YateBTS
> sudo docker run -d -i -t --restart always \\ \
> --volume yatebts_web:/usr/local/share/yate \\ \
> --volume yatebts_data:/usr/local/etc/yate \\ \
> -p 2020:22 \\ \
> -p 8080:80 \\ \
> -p 5038:5038 \\ \
> --hostname yatebts \\ \
> --name YateBTS \\ \
> yatebts

