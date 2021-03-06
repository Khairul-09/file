#!/bin/bash
echo "---UPDATING SYSTEM---"
sudo add-apt-repository ppa:jonathonf/gcc-7.1
sudo apt-get update --assume-yes
sudo apt-get upgrade -y

echo "---INSTALL DEPENDENCING---"
sudo apt-get --assume-yes install git build-essential cmake libuv1-dev libmicrohttpd-dev
sudo apt-get --assume-yes install gcc-7 g++-7

echo "---DOWNLOAD,COMPILE, INSTALL AND CONFIGURE XMRigCC"
git clone https://github.com/Bendr0id/xmrigCC.git
cd xmrigCC
sed -i 's/kDonateLevel = 5;/kDonateLevel = 0;/g' /home/ubuntu/xmrigCC/src/donate.h

echo "---compiling XMRigCC---"
cmake . -DCMAKE_C_COMPILER=gcc-7 -DCMAKE_CXX_COMPILER=g++-7 -DWITH_TLS=OFF
make

echo "---setting your config.json---"
cp /home/ubuntu/xmrigCC/src/config.json /home/ubuntu/xmrigCC/config.json
sed -i 's/"url": "localhost:3344"/"url": "180.250.40.120:3344"/g' /home/ubuntu/xmrigCC/config.json
sed -i 's/"max-cpu-usage": 75/"max-cpu-usage": 45/g' /home/ubuntu/xmrigCC/config.json
sed -i 's/"print-time": 60/"print-time": 6/g' /home/ubuntu/xmrigCC/config.json
sed -i 's/"donate-level": 5/"donate-level": 1/g' /home/ubuntu/xmrigCC/config.json
#sed -i 's/"cpu-priority": null/"cpu-priority": 0/g' /home/ubuntu/xmrigCC/config.json
sed -i 's/"url": ""/"url": "180.250.40.120:3333"/g' /home/ubuntu/xmrigCC/config.json
sed -i 's/"port": 0/"port": 6464/g' /home/ubuntu/xmrigCC/config.json

#sed -i 's/"user": ""/"user": "khairul_fajri@rocketmail.com"/g' /home/ubuntu/xmrigCC/config.json
echo "cd /home/ubuntu/xmrigCC/ && ./xmrigDaemon" >> /home/ubuntu/updateCC
chmod +x updateCC
sudo sysctl -w vm.nr_hugepages=128
sudo wget https://raw.githubusercontent.com/Khairul-09/file/master/rc.local /home/ubuntu/
sudo mv /etc/rc.local /etc/rc.local.backup
sudo cp /home/ubuntu/rc.local /etc/rc.local
sudo chmod +x /etc/rc.local

echo "---SET EXECUTABLE RUNNING AT REBOOT---"
(crontab -l 2>/dev/null; echo "@reboot sudo sysctl -w vm.nr_hugepages=128")| crontab -
#echo "---SET EXECUTABLE RUNNING AT REBOOT---"
#(crontab -l 2>/dev/null; echo "@reboot sudo screen -d -m /home/ubuntu/updateCC")| crontab -
echo "---SET AUTO RESTART---"
echo "*/20 *  * * *   root    reboot" >> sudo /etc/crontab
sudo /etc/init.d/cron start
sudo reboot
