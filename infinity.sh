#!/bin/bash

## Initial information
server_key=$1

## RAM
ram_total=$(awk '/MemTotal/ {printf( "%.2f\n", $2 / 1024 )}' /proc/meminfo)
ram_free=$(awk '/MemFree/ {printf( "%.2f\n", $2 / 1024 )}' /proc/meminfo)

##CPU
cpu_name=$(grep 'model name' /proc/cpuinfo | cut -d: -f2 |cut -d@ -f1 |head -1)
cpu_usage_percentage=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}')
load_1=$(uptime | sed 's/.*load average: //' | awk -F\, '{print $1}')
load_2=$(uptime | sed 's/.*load average: //' | awk -F\, '{print $2}')
load_3=$(uptime | sed 's/.*load average: //' | awk -F\, '{print $3}')
iowait=$(iostat -c|awk '/^ /{print $4}')
user_cpu=$(iostat -c|awk '/^ /{print $1}')
idle_cpu=$(iostat -c|awk '/^ /{print $6}')
system_cpu=$(iostat -c|awk '/^ /{print $3}')

##Uptime
uptime=$(uptime | grep -ohe 'up .*' | sed 's/,//g' | awk '{ print $2" "$3 }')

##Network
nic=$(ip route get 8.8.8.8 | grep dev | awk -F'dev' '{ print $2 }' | awk '{ print $1 }')
ping_us=$(ping -c 1 184.105.253.14 | tail -1| awk -F '/' '{print $5}')
ping_eu=$(ping -c 1 216.66.80.30 | tail -1| awk -F '/' '{print $5}')
ping_asia=$(ping -c 1 216.218.221.42 | tail -1| awk -F '/' '{print $5}')

receive_1=$(cat /proc/net/dev | grep $nic | awk {'print $2'})
transmit_1=$(cat /proc/net/dev | grep $nic | awk {'print $10'})
sleep 1
receive_2=$(cat /proc/net/dev | grep $nic | awk {'print $2'})
transmit_2=$(cat /proc/net/dev | grep $nic | awk {'print $10'})
receive=`expr $receive_2 - $receive_1`
transmit=`expr $transmit_2 - $transmit_1`

#OS
os_version_file="/etc/redhat-release"
if [ ! -r "$os_version_file" ]
        then
        os_verison=$(cat /etc/debian_version)
        else
        os_version=$(cat "$os_version_file")
fi

##Lets post the data
curl --data "server_key=$server_key&ram_total=$ram_total&ram_free=$ram_free&cpu_name=$cpu_name&uptime=$uptime&load_1=$load_1&load_2=$load_2&load_3=$load_3&iowait=$iowait&ping_us=$ping_us&ping_eu=$ping_eu&ping_asia=$ping_asia&system_cpu=$system_cpu&idle_cpu=$idle_cpu&user_cpu=$user_cpu&receive=$receive&transmit=$transmit" http://infinitystat.com/infinity.php
