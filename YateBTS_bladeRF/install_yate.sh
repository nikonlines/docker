#!/bin/bash

apt update

apt-get install software-properties-common

#-----------------------------------

#Для начало установим необходимые пакеты
apt-get install -y libbladerf-dev git subversion autoconf apache2 php libapache2-mod-php g++ make libgsm1-dev libgusb-dev rlwrap

#-----------------------------------

#Затем установим ПО для bladeRF
#sudo add-apt-repository ppa:bladerf/bladerf
#sudo apt-get update
#sudo apt-get install bladerf

#Установим FPGA в соответствии с вашей моделью bladeRF
#sudo apt-get install bladerf-fpga-hostedx40 # for bladeRF x40
#sudo apt-get install bladerf-fpga-hostedx115 # for bladeRF x115
#sudo apt-get install bladerf-fpga-hostedxa4 # for bladeRF 2.0 Micro A4
#sudo apt-get install bladerf-fpga-hostedxa9 # for bladeRF 2.0 Micro A9

#-----------------------------------

#Устанавливаем Yate
cd /opt
svn checkout http://voip.null.ro/svn/yate/trunk yate
cd yate
./autogen.sh
./configure
make install-noapi
ldconfig

#-----------------------------------

#Устанавливаем YateBTS
cd /opt
svn checkout http://voip.null.ro/svn/yatebts/trunk yatebts
cd yatebts/

#Откроем файл mbts/GPRS/MSInfo.cpp
# GPRSLOG(INFO,GPRS_MSG|GPRS_CHECK_OK) << "Multislot assignment for "<<this<<os;  - найдем эту строку
# GPRSLOG(INFO,GPRS_MSG|GPRS_CHECK_OK) << "Multislot assignment for "<<this<<(!os.fail()); и заменим ее на эту
#nano mbts/GPRS/MSInfo.cpp
sed -i 's/GPRSLOG(INFO,GPRS_MSG|GPRS_CHECK_OK) << "Multislot assignment for "<<this<<os;/GPRSLOG(INFO,GPRS_MSG|GPRS_CHECK_OK) << "Multislot assignment for "<<this<<(!os.fail());/' mbts/GPRS/MSInfo.cpp

#Тоже самое сделаем с файлом mbts/SGSNGGSN/Sgsn.cpp
# SGSNLOGF(INFO,GPRS_OK|GPRS_MSG,"SGSN","Removing SgsnInfo:"<<ss);
# SGSNLOGF(INFO,GPRS_OK|GPRS_MSG,"SGSN","Removing SgsnInfo:"<<(!ss.fail()));
#nano mbts/SGSNGGSN/Sgsn.cpp
sed -i 's/SGSNLOGF(INFO,GPRS_OK|GPRS_MSG,"SGSN","Removing SgsnInfo:"<<ss);/SGSNLOGF(INFO,GPRS_OK|GPRS_MSG,"SGSN","Removing SgsnInfo:"<<(!ss.fail()));/' mbts/SGSNGGSN/Sgsn.cpp

# SGSNLOGF(INFO,GPRS_OK|GPRS_MSG,"SGSN","Removing gmm:"<<ss);
# SGSNLOGF(INFO,GPRS_OK|GPRS_MSG,"SGSN","Removing gmm:"<<(!ss.fail()));
sed -i 's/SGSNLOGF(INFO,GPRS_OK|GPRS_MSG,"SGSN","Removing gmm:"<<ss);/SGSNLOGF(INFO,GPRS_OK|GPRS_MSG,"SGSN","Removing gmm:"<<(!ss.fail()));/' mbts/SGSNGGSN/Sgsn.cpp

#Когда файлы будут исправлены можно перейти к сборке проекта
./autogen.sh
./configure
make install

#-----------------------------------vvv

#Настраиваем Web GUI YateBTS
cd /var/www/html
ln -s /usr/local/share/yate/nipc_web yatebts
chmod -R a+w /usr/local/etc/yate

# http://localhost/yatebts - по этому адресу можно получить доступ к Web интерфейсу YateBTS
# Переходим на вкладку BTS Configuration и выставляем настройки:
# Radio.Band=900
# Radio.C0=75
# Identity.MCC=001
# Identity.MNC=01
# Radio.PowerManager.MaxAttenDB=35
# Radio.PowerManager.MinAttenDB=35

#----------------------------------

#Установка модуля SMSSend
cd /opt
git clone https://github.com/Ark444/YateBTS_smssend.git
cd YateBTS_smssend
make
make install