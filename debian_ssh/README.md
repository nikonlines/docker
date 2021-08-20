

sudo chmod 755 entrypoint.sh

sudo docker build . --no-cache --compress --tag debian_ssh

sudo docker run -d -i -t -p 2222:22 --name debian_ssh -h debian -v debian_ssh_opt:/opt debian_ssh

