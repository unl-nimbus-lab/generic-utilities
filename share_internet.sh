#! /bin/bash
#
# Non-persistent internet forwarding for Linux. Uses sudo.
# Run this on **HOST COMPUTER ONLY**.
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

## Two styles for odroid/pi/other-computer:
#    1. Non-persistent settings:
#         sudo route add default gw <host-computer-ip> <odroid-eth-whatever>
#         echo "nameserver 8.8.8.8" | sudo tee -a /etc/resolv.conf
#    2. Automatic persistent network interface:
#       Edit the file /etc/network/interfaces to add these lines:
#         auto eth0
#         iface eth0 inet static
#         address abc.def.ghi.JKL                       # static ip for odroid/pi
#         network abc.0.0.0
#         broadcast abc.0.0.255
#         netmask 255.255.255.0
#         up route add default gw abc.def.ghi.XYZ       # host computer's ip (note XYZ)
#         dns-nameservers 8.8.8.8
#       The second-last line works beautifully if you are on Ubuntu16+. Not tested on
#       previous versions. Simple addr. are easier (50.0.0.1 for host, 50.0.0.2 for odroid/pi).
