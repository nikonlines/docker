#!/bin/bash

#FileBrowser container
docker run -d -it --name "FileBrowser" \
--hostname "FileBrowser" -p 8080:80 \
-v "filebrowser_data:/data" \
-v "filebrowser_srv:/srv" \
filebrowser/filebrowser:latest

#Example
#-v "nginx_data:/srv/nginx_data" \
#-v "nginx_log:/srv/nginx_log" \
