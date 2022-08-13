#!/bin/bash
chmod +x futurerestore
chmod +x install.sh
chmod +x main.sh
chmod +x files/irecovery
chmod +x files/lsusb
echo "*** FutureRestore Booter ***"
./main.sh
clear
echo "********* FutureRestore is Starting **********"
sleep 5
./install.sh
