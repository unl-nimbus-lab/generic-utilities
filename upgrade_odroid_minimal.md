>Make the mimimal image a little more useful with these installations.
Needs internet (duh!). Can use share_internet.sh to do so, since other
methods like usb-wifi adapters probably won't work. Tested with Ubuntu
16.04 (minimal) on kernel 4.14.
>
>   --aj / NimbusLab / Nov 4, 2019.

#### Basic upgrades first:
```
apt-get update && apt-get upgrade && apt-get dist-upgrade
```
#### Kernel upgrade:
```
apt-get install linux-image-xu3
reboot
```

#### Linux headers needed for some modules (like librealsense):
```
apt-get install linux-headers-$(uname -r)
reboot
```

#### Install drivers for Odroid's GPU:
```
apt-get install mali-fbdev
# other useful stuff
apt-get install git subversion build-essential
```

#### Follow ros (kinetic) installation steps for keys and repository ..
```
..
# only install basic stuff you need
apt-get install ros-kinetic-desktop ros-kinetic-ddynamic-reconfigure ros-kinetic-mavros*
rosdep init
rosdep update
```

**Install geographic lib, needed by mavros**
```
wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh
# make it executable, or call `bash install_geographiclib_datasets.sh`
./install_geographiclib_datasets.sh
```


#### REALSENSE CAMERA STUFF
```
apt-get install libssl-dev libusb-1.0-0-dev pkg-config libgtk-3-dev libglfw3-dev
```
#### Then follow instructions in doc/installation.md and look out for Odroid-related stuff.
