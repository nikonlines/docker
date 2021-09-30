#!/bin/bash

#Container name (Default: 'portainer') 
CONTAINER_NAME="portainer_ssl"

#Default port
CONTAINER_PORT=9000
CONTAINER_SSL_PORT=9443

#Selected cert mode ('letsencrypt' or 'default' or 'no')
CERT_MODE="default"
#CERT_MODE="letsencrypt"

#Edit cert name if selected CERT_MODE='letsencrypt'
CERT_NAME="portainer.local"

#Update cert for Default
CERT_UPDATE=true         #True or False

#Change to your company details
COUNTRY="XX"             #Country Name (2 letter code)
STATE=""                 #State or Province Name (full name)
LOCALCITY=""             #Locality Name (eg, city)
ORGANIZATION=""          #Organization Name (eg, company)
ORGANIZATION_UNIT=""     #Organizational Unit Name (eg, section)
COMMON_NAME="portainer"  #Common Name (e.g. server FQDN or YOUR name)
EMAIL=""                 #Email Address

#----------------------------

#Letsencrypt cert config
LETSENCRYPT_CERT_DIR="/etc/letsencrypt"
LETSENCRYPT_CERT_NAME="fullchain.pem"
LETSENCRYPT_CERT_KEY="privkey.pem"

DEFAULT_CERT_DIR="/etc/docker/certs"
DEFAULT_CERT_NAME="portainer.crt"
DEFAULT_CERT_KEY="portainer.key"
DEFAULT_CERT_DAYS=3650 #The number of days to certify the certificate for. 3650 is ten years. You can use any positive integer.
DEFAULT_CERT_SIZE=2048 #Creates a new certificate request and 4096 bit RSA key. The default one is 2048 bits.

#----------------------------

if $CERT_UPDATE ; then
 if ! [ -d $DEFAULT_CERT_DIR ]; then
   mkdir -p $DEFAULT_CERT_DIR
 fi

 cd $DEFAULT_CERT_DIR

 sudo openssl req -x509 -nodes -days ${DEFAULT_CERT_DAYS} -newkey rsa:${DEFAULT_CERT_SIZE} -keyout $DEFAULT_CERT_KEY -out $DEFAULT_CERT_NAME \
  -subj "/C=${COUNTRY}/ST=${STATE}/L=${LOCALCITY}/O=${ORGANIZATION}/OU=${ORGANIZATION_UNIT}/CN=${COMMON_NAME}/emailAddress=${EMAIL}"
fi

#----------------------------

docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME
#docker rmi portainer/portainer-ce

docker pull portainer/portainer-ce

case "$CERT_MODE" in
 "letsencrypt" ) docker run -d  --name $CONTAINER_NAME --restart always \
                            -p ${CONTAINER_PORT}:${CONTAINER_PORT} \ 
                            -p ${CONTAINER_SSL_PORT}:${CONTAINER_SSL_PORT} \
                            -v /var/run/docker.sock:/var/run/docker.sock \
                            -v portainer_data:/data \
                            -v letsencrypt_data:${LETSENCRYPT_CERT_DIR} \ 
                            portainer/portainer-ce \
                            --sslcert ${LETSENCRYPT_CERT_DIR}/live/${CERT_NAME}/${LETSENCRYPT_CERT_NAME} \
                            --sslkey ${LETSENCRYPT_CERT_DIR}/live/${CERT_NAME}/${LETSENCRYPT_CERT_KEY}
 ;;
 "default"     ) docker run -d  --name $CONTAINER_NAME --restart always \
                            -p ${CONTAINER_PORT}:${CONTAINER_PORT} \ 
                            -p ${CONTAINER_SSL_PORT}:${CONTAINER_SSL_PORT} \
                            -v /var/run/docker.sock:/var/run/docker.sock \
                            -v portainer_data:/data \
                            -v ${DEFAULT_CERT_DIR}:/certs \
                            portainer/portainer-ce \
                            --sslcert /certs/${DEFAULT_CERT_NAME} \
                            --sslkey /certs/${DEFAULT_CERT_KEY}
 ;;
 *             ) docker run -d  --name $CONTAINER_NAME --restart always \
                            -p ${CONTAINER_PORT}:${CONTAINER_PORT} \
                            -p ${CONTAINER_SSL_PORT}:${CONTAINER_SSL_PORT} \
                            -v /var/run/docker.sock:/var/run/docker.sock \
                            -v portainer_data:/data \
                            portainer/portainer-ce
 ;;
esac

#----------------------------



