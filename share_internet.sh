#! /bin/bash
#
# Non-persistent internet forwarding for Linux. Uses sudo.
# NOTE:
#   -o $1 (eth0)   :   This is your computer's internet connection
#   -i $2 (eth1)   :   This is what you want to share internet to
#   20.0.0.0       :   The 20.. network to which you're sharing
#
# I have the eth0 as a NAT connection (if using VM) and eth1 as bridged.
# Non-VMs don't need to worry at all.
#   -- aj

if [ $# -ne 3 ]; then
  if [ $# == 2 ]; then
    NTWRK=20.0.0.0
  else
    echo "Not enough args!"
    echo -e "\t Usage: ${0} <from-adapter> <to-adapter> <to-network>"
    echo -e "\t Example: ${0} eth42 eth43 20.0.0.0"
    echo "Default network is at 20.0.0.0 if not provided."
    exit 1
  fi
else
  NTWRK=$3
fi

sudo iptables -A FORWARD -o $1 -i $2 -s ${NTWRK}/24 -m conntrack --ctstate NEW -j ACCEPT
sudo iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -t nat -F POSTROUTING
sudo iptables -t nat -A POSTROUTING -o $1 -j MASQUERADE
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
echo "Done! Check /etc/sysctl.conf for net.ip_forward if needed.."

# following lines go on the odroid/pi/other-computer
# sudo route add default gw 20.0.0.2 eth-whatever
# echo "nameserver 8.8.8.8" | sudo tee -a /etc/resolv.conf

