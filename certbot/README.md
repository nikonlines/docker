
#Install CertBot in container NGINX

apt update
apt install certbot python-certbot-nginx

certbot certonly --force-renewal --nginx -d <site.domain>
