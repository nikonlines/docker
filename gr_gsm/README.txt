
sudo docker build . --no-cache --compress --tag gr-gsm:ubuntu

sudo docker run -d -i -t --restart always \
--privileged -v /dev/bus/usb:/dev/bus/usb \
--name gr-gsm \
--hostname gr-gsm \
-p 4729:4729 \
gr-gsm:ubuntu
