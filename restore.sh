#!/bin/bash
rm -rf FutureRestore
git clone https://github.com/80036nd/FutureRestore
chmod +x /FutureRestore/futurerestore
chmod +x install.sh
chmod +x main.sh
chmod +x files/igetnonce
chmod +x files/irecovery
chmod +x files/lsusb
./main.sh
clear
echo "********* FutureRestore is Starting **********"
sleep 5
./install.sh
