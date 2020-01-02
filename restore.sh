#!/bin/bash
chmod +x futurerestore
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
