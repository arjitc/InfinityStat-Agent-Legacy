# InfinityStat
The InfinityStat monitoring agent

## Prerequisites
InfinityStat needs 2 packages installed on your system to function,
* sysstat - To collect various bits of data that we graph up for you
* curl - To POST the data collected by sysstat to us
* chkconfig - To start the agent on boot

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

    yum install curl sysstat chkconfig (CentOS/Fedora/Scientific/RHEL/RHEL based distros)
    apt-get update && apt-get install curl sysstat chkconfig (Debian/Ubuntu)
