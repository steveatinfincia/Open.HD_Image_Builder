# This runs in context if the image (CHROOT)
# Any native compilation can be done here
# Do not use log here, it will end up in the image

#!/bin/bash

#Install Raspi2png
cd /home/pi
cd raspi2png
sudo make
sudo make install

# Install mavlink-router
cd /home/pi
cd mavlink-router
sudo ./autogen.sh && sudo ./configure CFLAGS='-g -O2' \
        --sysconfdir=/etc --localstatedir=/var --libdir=/usr/lib64 \
    --prefix=/usr
sudo make

# Install cmavnode
cd /home/pi
cd cmavnode
sudo mkdir build && cd build
sudo cmake ..
sudo make
sudo make install


cd /home/pi/
cd LiFePO4wered-Pi
mkdir -p build/DAEMON
mkdir -p build/CLI
mkdir -p build/SO
gcc -c lifepo4wered-access.c -o build/DAEMON/lifepo4wered-access.o -std=c99 -Wall -O2
gcc -c lifepo4wered-data.c -o build/DAEMON/lifepo4wered-data.o -std=c99 -Wall -O2
gcc -c lifepo4wered-daemon.c -o build/DAEMON/lifepo4wered-daemon.o -std=c99 -Wall -O2
gcc -c lifepo4wered-access.c -o build/SO/lifepo4wered-access.o -std=c99 -Wall -O2 -fpic
gcc -c lifepo4wered-data.c -o build/SO/lifepo4wered-data.o -std=c99 -Wall -O2 -fpic
gcc -c lifepo4wered-access.c -o build/CLI/lifepo4wered-access.o -std=c99 -Wall -O2
gcc -c lifepo4wered-data.c -o build/CLI/lifepo4wered-data.o -std=c99 -Wall -O2
gcc -c lifepo4wered-cli.c -o build/CLI/lifepo4wered-cli.o -std=c99 -Wall -O2
gcc build/DAEMON/lifepo4wered-access.o build/DAEMON/lifepo4wered-data.o build/DAEMON/lifepo4wered-daemon.o -o build/DAEMON/lifepo4wered-daemon
gcc build/SO/lifepo4wered-access.o build/SO/lifepo4wered-data.o -o build/SO/liblifepo4wered.so -shared
gcc build/CLI/lifepo4wered-access.o build/CLI/lifepo4wered-data.o build/CLI/lifepo4wered-cli.o -o build/CLI/lifepo4wered-cli
./INSTALL.sh

apt-get --yes --force-yes install gstreamer1.0-alsa


