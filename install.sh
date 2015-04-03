#!/bin/bash
install_key=$1
distro="cat /etc/debian_version"
if [ -z "$install_key" ];
    then
    echo "Server key missing. Exiting install."
    exit 0
fi
## install key is set, lets proceed with install of curl to post data and sysstat to get some I/O data
echo "Installing sysstat and curl packages"
apt-get update || yum update -y
apt-get install sysstat curl chkconfig -y || yum install sysstat curl chkconfig -y
wget https://raw.githubusercontent.com/arjitc/InfinityStat/master/infinitystat -O /etc/init.d/infinitystat --no-check-certificate
chmod +x /etc/init.d/infinitystat
wget https://raw.githubusercontent.com/arjitc/InfinityStat/master/infinity.sh -O /bin/infinitystat --no-check-certificate
chmod +x /bin/infinitystat
touch /etc/infinitystat.conf
echo "$1" >> /etc/infinitystat.conf
chkconfig infinitystat on
echo "Install complete"
echo "To start InfinityStat: service infinitystat start"
echo "To stop InfinityStat: service infinitystat stop"
echo "===="
echo "Starting InfinityStat service"
/etc/init.d/infinitystat start
echo "===="
