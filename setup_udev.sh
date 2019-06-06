#! /bin/bash
# Use this to setup a rule in the udev file
# Two arguments are:
#   1: the full device name (like /dev/ttyUSB42)
#   2: the /dev/suffix-name you want to associate (only provide suffix-name)
# To find out more about your device, use something like this:
#   $ udevadm info -a -n /dev/ttyUSB0 | grep idProduct
#
# -- aj / June 2018

if [ "$#" -ne 2 ]; then
  echo -e "That is not how you use this script! Run \"head $0\""
  exit 1
fi

all_info=$( udevadm info -a -n $1 );
serial_name=$( echo ${all_info#*ATTRS{serial\}==} | cut -d '"' -f 2 );
idV=$( echo ${all_info#*ATTRS{idVendor\}==} | cut -d '"' -f 2 );
idP=$( echo ${all_info#*ATTRS{idProduct\}==} | cut -d '"' -f 2 );

echo "Going to write the following line to rules:"
echo -e "  SUBSYSTEMS==\"usb\", ATTRS{idVendor}==\"$idV\", ATTRS{idProduct}==\"$idP\", ATTRS{serial}==\"$serial_name\", SYMLINK+=\"$2\", MODE=\"0666\""
read -r -p "Continue? [y/n] " userinput

if [ "$userinput" = "y" ] || [ "$userinput" = "Y" ]; then
  echo -e "SUBSYSTEMS==\"usb\", ATTRS{idVendor}==\"$idV\", ATTRS{idProduct}==\"$idP\", ATTRS{serial}==\"$serial_name\", SYMLINK+=\"$2\", MODE=\"0666\"" >> /etc/udev/rules.d/99-usb-serial.rules
  echo "Done!"
else
  echo "Stopping on user input!"
fi

# For inspecting what happened, use the following variables:
# echo $serial_name
# echo $idV
# echo $idP
# Thanks to Ashraful for forcing me to write this.
