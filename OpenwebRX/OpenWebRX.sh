#!/bin/bash

#OpenWebRX container
docker run -d -it --name "OpenWebRX" \
--hostname "OpenWebRX" -p 8073:8073 \
--privileged -v "/dev/bus/usb:/dev/bus/usb" \
-v "openwebrx_data:/etc/openwebrx" \
-v "openwebrx_tmp:/tmp/openwebrx" \
-v "openwebrx_lib:/var/lib/openwebrx" \
-e OPENWEBRX_ADMIN_USER="admin" \
-e OPENWEBRX_ADMIN_PASSWORD="admin" \
jketterl/openwebrx-full:stable
