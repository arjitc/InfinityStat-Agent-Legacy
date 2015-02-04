#!/bin/bash
if [ $1 == "update" ]; then
	wget https://raw.githubusercontent.com/arjitc/InfinityStat/master/infinity.sh -O /bin/infinitystat --no-check-certificate
	chmod +x /bin/infinitystat
	wget https://raw.githubusercontent.com/arjitc/InfinityStat/master/infinitystat -O /etc/init.d/infinitystat --no-check-certificate
	chmod +x /etc/init.d/infinitystat
	echo "Update Successful"
	exit 
fi

while true
do
	## Initial information
	server_key=$(cat /etc/infinitystat.conf)

	## Kernel info
	kernel_info=$(uname -r)

	## RAM
	ram_total=$(awk '/^MemTotal/ {printf( "%.2f\n", $2 / 1024 )}' /proc/meminfo)
	ram_free=$(awk '/^MemFree/ {printf( "%.2f\n", $2 / 1024 )}' /proc/meminfo)
	ram_cached=$(awk '/^Cached:/ {printf( "%.2f\n", $2 / 1024 )}' /proc/meminfo)
	ram_buffers=$(awk '/^Buffers:/ {printf( "%.2f\n", $2 / 1024 )}' /proc/meminfo)

	##CPU
	cpu_name=$(grep 'model name' /proc/cpuinfo | cut -d: -f2 |cut -d@ -f1 |head -1)
	cpu_usage_percentage=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}')
	cpu_freq=$(cat /proc/cpuinfo | grep MHz | tail -n1 | awk '{print $4}')
	load_1=$(uptime | sed 's/.*load average: //' | awk -F\, '{print $1}')
	load_2=$(uptime | sed 's/.*load average: //' | awk -F\, '{print $2}')
	load_3=$(uptime | sed 's/.*load average: //' | awk -F\, '{print $3}')
	iowait=$(iostat -c|awk '/^ /{print $4}')
	user_cpu=$(iostat -c|awk '/^ /{print $1}')
	idle_cpu=$(iostat -c|awk '/^ /{print $6}')
	system_cpu=$(iostat -c|awk '/^ /{print $3}')
	cpu_count=$(cat /proc/cpuinfo | grep "physical id" | sort -u | wc -l)
	core_count=$(cat /proc/cpuinfo | grep "siblings" | sort -u | awk '{print $3}')

	##Uptime
	uptime=$(uptime | grep -ohe 'up .*' | sed 's/,//g' | awk '{ print $2" "$3 }')

	##Network
	nic=$(ip route get 8.8.8.8 | grep dev | awk -F'dev' '{ print $2 }' | awk '{ print $1 }')
	ping_us=$(ping -c 1 184.105.253.14 | tail -1| awk -F '/' '{print $5}')
	ping_eu=$(ping -c 1 216.66.80.30 | tail -1| awk -F '/' '{print $5}')
	ping_asia=$(ping -c 1 216.218.221.42 | tail -1| awk -F '/' '{print $5}')

	receive_1=$(cat /proc/net/dev | grep $nic | awk {'print $2'})
	pps_receive_1=$(cat /proc/net/dev | grep $nic | awk {'print $3'})
	transmit_1=$(cat /proc/net/dev | grep $nic | awk {'print $10'})
	pps_transmit_1=$(cat /proc/net/dev | grep $nic | awk {'print $11'})
	sleep 1
	receive_2=$(cat /proc/net/dev | grep $nic | awk {'print $2'})
	pps_receive_2=$(cat /proc/net/dev | grep $nic | awk {'print $3'})
	transmit_2=$(cat /proc/net/dev | grep $nic | awk {'print $10'})
	pps_transmit_2=$(cat /proc/net/dev | grep $nic | awk {'print $11'})
	receive=`expr $receive_2 - $receive_1`
	transmit=`expr $transmit_2 - $transmit_1`
	pps_receive=`expr $pps_receive_2 - $pps_receive_1`
	pps_transmit=`expr $pps_transmit_2 - $pps_transmit_1`

	#OS
	distro=$(egrep -i '^red\ hat|^fedora|^suse|^centos|^ubuntu|^debian' /etc/issue)
	##if [ ! -r "$distro" ]
	##        then
	##        distro="Unknown"
	##fi

	##Lets post the data
	curl --data "server_key=$server_key&kernel_info=$kernel_info&ram_total=$ram_total&ram_free=$ram_free&ram_cached=$ram_cached&ram_buffers=$ram_buffers&cpu_freq=$cpu_freq&cpu_name=$cpu_name&cpu_count=$cpu_count&core_count=$core_count&uptime=$uptime&load_1=$load_1&load_2=$load_2&load_3=$load_3&iowait=$iowait&ping_us=$ping_us&ping_eu=$ping_eu&ping_asia=$ping_asia&system_cpu=$system_cpu&idle_cpu=$idle_cpu&user_cpu=$user_cpu&receive=$receive&transmit=$transmit&pps_receive=$pps_receive&pps_transmit=$pps_transmit&distro=$distro" http://infinitystat.com/infinity.php

sleep 300
done
