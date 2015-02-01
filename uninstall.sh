#!/bin/bash
read -p "Are you sure you want to uninstall InfinityStat (y/n)?" CONT
if [ "$CONT" == "y" ]; then
  echo "Stopping InfinityStat";
  pkill -f /bin/infinitystat
  echo "Deleting init script for InfinityStat";
  rm -f /etc/init.d/infinitystat
  echo "Deleting InfinityStat config file";
  rm -f /etc/infinitystat.conf
  echo "Deleting InfinityStat script";
  rm -f /bin/infinitystat
  echo "Uninstall complete."
else
  echo "InfinityStat not uninstalled";
fi
