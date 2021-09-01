#!/bin/bash

if [ -n "$ROOT_PASSWORD" ]; then
 echo "root:${ROOT_PASSWORD}" | chpasswd
fi

if [ "$ROOT_SSH_ENABLE" == "true" ]; then
 sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
fi

if [ -n "$USER_LOGIN" ]; then
 useradd -m -s /bin/bash -G sudo ${USER_LOGIN}
fi

if [ -n "$USER_PASSWORD" ]; then
 echo "${USER_LOGIN}:${USER_PASSWORD}" | chpasswd
fi

service ssh restart
service apache2 restart
yate -s &

#----------------------

if [ -n "$1" ]; then
 bash -c "$1"
fi

bash
