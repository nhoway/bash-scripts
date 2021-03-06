#!/bin/bash
CDIR="$(dirname `realpath -s $0`)/.."
CCNF="$CDIR/.conf"

# PROMPT CUSTOM VALUES
########################################

. $CDIR/scripts/store-config.sh
if [ -z "$1" ]; then 
  FAILOVERIP="$(askconfig $CCNF FAILOVERIP)";
else
  FAILOVERIP=$1;
fi

INTERFACE="$(ifconfig | grep -i 'ethernet' | awk '{ print $1 }')"

if [ "$(echo \"$INTERFACE\" | wc -w)" -gt "1" ]; then
  INTERFACE="$(askconfig $CCNF INTERFACE 'default network interface name')";
fi

CONFIG="/etc/network/interfaces.d/50-cloud-init.cfg"
sudo touch "$CONFIG"
sudo sed -i "/$INTERFACE/d" "$CONFIG"

# Switch from default server IP (given by OVH DHCP Server) to the failover
# Outbound connections will use the failover IP
sudo tee -a "$CONFIG" <<EOF
auto $INTERFACE
iface $INTERFACE inet static
        address $FAILOVERIP
        netmask 255.255.255.255
        broadcast $FAILOVERIP

auto $INTERFACE:0
iface $INTERFACE:0 inet dhcp
EOF

# Docs about network precedence here
# l1: https://help.ubuntu.com/community/NetworkConfigurationCommandLine/Automatic
# l2: https://serverfault.com/questions/806090/how-to-set-default-external-ip-address-on-ubuntu-server
# l3: https://serverfault.com/questions/41077/use-specific-interface-for-outbound-connections-ubuntu-9-04

sudo service networking restart