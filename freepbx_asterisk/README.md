

sudo chmod 755 entrypoint.sh

sudo docker build . --no-cache --compress --tag freepbx_asterisk

sudo docker run -d -i -t -p 2222:22 --name freepbx_asterisk -h freepbx_asterisk

