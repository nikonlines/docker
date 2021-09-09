
sudo docker build . --no-cache --compress --tag gr-gsm:ubuntu

sudo docker run -d -i -t --restart always \
--privileged -v /dev/bus/usb:/dev/bus/usb \
--name gr-gsm \
--hostname gr-gsm \
-p 4729:4729 \
gr-gsm:ubuntu

#**************************************

export PYTHONPATH=/usr/local/lib/python3/dist-packages/:$PYTHONPATH
#or
sudo export PYTHONPATH=/usr/local/lib/python3/dist-packages/:$PYTHONPATH

grgsm_livemon
sudo wireshark -k -f udp -Y gsmtap -i lo

grgsm_scanner -b GSM900
#or
kal -s GSM900
