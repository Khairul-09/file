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
echo "---Contoh jika menggunakan xmrig-Proxy---"
sed -i 's/"url": "localhost:3344"/"url": "12.200.25.30:3344"/g' /home/ubuntu/xmrigCC/config.json
#sed -i 's/"max-cpu-usage": 75/"max-cpu-usage": 45/g' /home/ubuntu/xmrigCC/config.json
sed -i 's/"print-time": 60/"print-time": 6/g' /home/ubuntu/xmrigCC/config.json
sed -i 's/"donate-level": 5/"donate-level": 1/g' /home/ubuntu/xmrigCC/config.json
#sed -i 's/"cpu-priority": null/"cpu-priority": 0/g' /home/ubuntu/xmrigCC/config.json
sed -i 's/"url": ""/"url": "12.200.25.30:3333"/g' /home/ubuntu/xmrigCC/config.json
sed -i 's/"port": 0/"port": 6464/g' /home/ubuntu/xmrigCC/config.json
sudo sysctl -w vm.nr_hugepages=128
sudo screen /home/ubuntu/xmrigCC/xmrigDaemon
