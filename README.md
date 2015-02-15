# InfinityStat
InfinityStat monitoring agent

## Prerequisites
InfinityStat needs 2 packages installed on your system to function,
* sysstat
* curl

sysstat (ie, iostat) is used to get the following stats from your system
* iowait https://github.com/arjitc/InfinityStat/blob/master/infinity.sh#L66
* user_cpu https://github.com/arjitc/InfinityStat/blob/master/infinity.sh#L67
* idle_cpu https://github.com/arjitc/InfinityStat/blob/master/infinity.sh#L68
* system_cpu https://github.com/arjitc/InfinityStat/blob/master/infinity.sh#L69

curl is used to POST the final data collected to us

## Installation

You'll need a account first to setup InfinityStat on your server, InfinityStat is free to use and signup at https://infinitystat.com/

Upon singning up, you'll get an option to add your server into your account after which you'll be presented with the install commands, similar to the commands listed below but with the unique SERVER_KEY as well which links your server with your account.

    wget https://raw.githubusercontent.com/arjitc/InfinityStat/master/install.sh --no-check-certificate
    chmod +x install.sh
    sh install.sh SERVER_KEY

## Debugging

Sometimes sysstat and curl don't get installed which ends up with no data getting sent to us or incomplete data getting sent to us if sysstat is missing which can be fixed with running either of the 2 options listed below

Automated fix:

    infinitystat fix

Manual fix:

    yum install curl sysstat (CentOS/Fedora/Scientific/RHEL/RHEL based distros)
    apt-get update && apt-get install curl sysstat (Debian/Ubuntu)
