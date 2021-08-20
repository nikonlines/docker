#!/bin/bash

FREEPBX_VERSION="16.0-latest"
ASTERISK_VERSION="18-current"
#DAHDI_VERSION=""
#LibPRI_VERSION=""
WEB_ROOT=""
#
LINUX_HEADERS="4.19.0-17-all"
#
PHP_VERSION="7.4"
NODEJS_VERSION="16.x"
MARIADB_CONNECTOR_ODBC="3.1.13"

#------------------------------

#Update Your System
apt-get update && apt-get upgrade -y

#Install Required
apt-get install -y wget gnupg2 lsb-release curl git sudo

#Install Kernel Source for Asterisk
if [ -z "${LINUX_HEADERS}" ]; then LINUX_HEADERS=`uname -r`; fi
apt-get install -y linux-headers-${LINUX_HEADERS}

apt-get install -y openssh-server apache2 mariadb-server mariadb-client bison flex \
  sox libncurses5-dev libssl-dev mpg123 libxml2-dev libnewt-dev sqlite3 \
  libsqlite3-dev pkg-config automake libtool autoconf unixodbc-dev uuid uuid-dev \
  libasound2-dev libogg-dev libvorbis-dev libicu-dev libcurl4-openssl-dev libical-dev libneon27-dev libsrtp2-dev \
  libspandsp-dev subversion libtool-bin python-dev unixodbc dirmngr sendmail-bin sendmail


#Install the SURY Repository Signing Key
wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add -

#Install the SURY Repository and Update  your system packages
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
apt-get update && apt-get upgrade -y

apt-get install -y php${PHP_VERSION} php${PHP_VERSION}-curl php${PHP_VERSION}-cli \
  php${PHP_VERSION}-common php${PHP_VERSION}-mysql php${PHP_VERSION}-gd \
  php${PHP_VERSION}-mbstring php${PHP_VERSION}-intl php${PHP_VERSION}-xml php-pear
		
#Install nodejs
curl -fsSL https://deb.nodesource.com/setup_${NODEJS_VERSION} | bash -
apt-get install -y nodejs

#Install MariaDB ODBC
#cd /usr/src/
#wget https://wiki.freepbx.org/download/attachments/202375584/libssl1.0.2_1.0.2u-1_deb9u4_amd64.deb
#dpkg -i libssl1.0.2_1.0.2u-1_deb9u4_amd64.deb
#rm -f libssl1.0.2_1.0.2u-1_deb9u4_amd64.deb

#wget https://wiki.freepbx.org/download/attachments/122487323/mariadb-connector-odbc_3.0.7-1_amd64.deb
#dpkg -i mariadb-connector-odbc_3.0.7-1_amd64.deb
#rm -f mariadb-connector-odbc_3.0.7-1_amd64.deb

apt-get install -y libssl1.1

#https://downloads.mariadb.org/connector-odbc/${MARIADB_CONNECTOR_ODBC}/
https://downloads.mariadb.com/Connectors/odbc/connector-odbc-${MARIADB_CONNECTOR_ODBC}/mariadb-connector-odbc-${MARIADB_CONNECTOR_ODBC}-src.tar.gz
tar xvfz mariadb-connector-odbc-${MARIADB_CONNECTOR_ODBC}-src.tar.gz
rm -f mariadb-connector-odbc-${MARIADB_CONNECTOR_ODBC}-src.tar.gz
cd mariadb-connector-odbc-*


#If the MariaDB server works in 'STRICT_TRANS_TABLES' mode you need to change mode in /etc/mysql/my.conf
sed -i 's/sql_mode=NO_ENGINE_SUBSTITUTION, STRICT_TRANS_TABLES/sql_mode=NO_ENGINE_SUBSTITUTION/' /etc/mysql/my.conf

#--- Install and Configure Asterisk ---

#Download and compile and install DAHDI.
cd /usr/src
wget http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-current.tar.gz
tar xvfz dahdi-linux-complete-current.tar.gz
rm -f dahdi-linux-complete-current.tar.gz
cd dahdi-linux-complete-*
make all
make install
make install-config

#Download and compile and install LibPRI.
cd /usr/src
wget http://downloads.asterisk.org/pub/telephony/libpri/libpri-current.tar.gz
tar xvfz libpri-current.tar.gz
rm -f libpri-current.tar.gz
cd libpri-*
make
make install

#Download Asterisk source files.
cd /usr/src
wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-${ASTERISK_VERSION}.tar.gz
tar xvfz asterisk-${ASTERISK_VERSION}.tar.gz
rm -f asterisk-${ASTERISK_VERSION}.tar.gz
cd asterisk-*
contrib/scripts/get_mp3_source.sh
contrib/scripts/install_prereq install
./configure --with-pjproject-bundled --with-jansson-bundled
make menuselect.makeopts
menuselect/menuselect --enable app_macro --enable format_mp3 menuselect.makeopts
#
make
make install
make config
ldconfig
update-rc.d -f asterisk remove

#--- Install and Configure FreePBX ---

#Create the Asterisk user and set base file permissions.
useradd -m asterisk
chown asterisk. /var/run/asterisk
chown -R asterisk. /etc/asterisk
chown -R asterisk. /var/{lib,log,spool}/asterisk
chown -R asterisk. /usr/lib/asterisk
rm -rf /var/www/html

#A few small modifications to Apache.
sed -i 's/\(^upload_max_filesize = \).*/\120M/' /etc/php/${PHP_VERSION}/apache2/php.ini
cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf_orig
sed -i 's/^\(User\|Group\).*/\1 asterisk/' /etc/apache2/apache2.conf
sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
a2enmod rewrite
service apache2 restart

#Configure ODBC
cat <<EOF > /etc/odbcinst.ini
[MySQL]
Description = ODBC for MySQL (MariaDB)
Driver = /usr/local/lib/libmaodbc.so
FileUsage = 1
EOF

cat <<EOF > /etc/odbc.ini
[MySQL-asteriskcdrdb]
Description = MySQL connection to 'asteriskcdrdb' database
Driver = MySQL
Server = localhost
Database = asteriskcdrdb
Port = 3306
Socket = /var/run/mysqld/mysqld.sock
Option = 3
EOF

#Download and install FreePBX
cd /usr/src
wget http://mirror.freepbx.org/modules/packages/freepbx/${PHP_VERSION}/freepbx-${FREEPBX_VERSION}.tgz
tar vxfz freepbx-${FREEPBX_VERSION}.tgz
rm -f freepbx-${FREEPBX_VERSION}.tgz
touch /etc/asterisk/{modules,cdr}.conf
cd freepbx
./start_asterisk start

if [ -z "${WEB_ROOT}" ]; then
  ./install -n
else
  ./install --webroot=${WEB_ROOT} -n
  sed -i 's/\/var\/www\/html/${WEB_ROOT}/g' /etc/apache2/sites-available/000-default.conf
  sed -i 's/\/var\/www\/html/${WEB_ROOT}/g' /etc/apache2/sites-available/default-ssl.conf
  service apache2 restart
fi

#Install all Freepbx modules
fwconsole ma disablerepo commercial
fwconsole ma installall
fwconsole ma delete firewall
fwconsole reload
fwconsole restart




