#!/bin/bash

rm blob.shsh2
clear
echo "Please drag and drop SHSH file into terminal:"
read shsh

if [ ${shsh: -6} == ".shsh2" ] || [ ${shsh: -5} == ".shsh" ]
then
    echo "File verified as SHSH2 file, continuing ..."
else
    echo "[Exiting] Please ensure that the file extension is either .shsh or .shsh2 and retry"
    exit
fi

cp -v $shsh ./blob.shsh2

echo "Getting generator from SHSH"

generator=$(grep "<string>0x" $shsh | cut -c10-27)

if [ -z "$generator" ]
then
    echo "[Exiting] SHSH does not contain a generator!"
    echo "SHSH saved with https://shsh.host (will show generator) or https://tsssaver.1conan.com (in noapnonce folder) are acceptable"
    exit
else
    echo "SHSH generator is: $generator"
fi

echo "Please connect device in DFU mode."
read -p "Press ENTER when ready to continue <-"

device=$(./files/irecovery -q | grep "PRODUCT" | cut -f 2 -d ":" | cut -c 2-)

if [ -z "$device" ]
then
    echo "[Exiting] No device found."
    exit
else
    if [ ! -e ./files/ibss.$device.img4 ]
    then
      echo "[Exiting] Unsupported device."
      exit
    fi

    echo "Supported device found: $device"
fi

if [ "$device" == "iPhone10,3" ] || [ "$device" == "iPhone10,6" ]
then
    if [ ! -d ./ipwndfuA11 ]; then
      git clone https://github.com/MatthewPierson/ipwndfuA11.git
    fi

    cd ipwndfuA11
else
    if [ ! -d ./ipwndfu_public ]; then
      git clone https://github.com/MatthewPierson/ipwndfu_public.git
    fi

    cd ipwndfu_public
fi

echo "Starting ipwndfu"
check=0
until [ $check == 1 ]
do
    sleep 2
    echo "The script will run ipwndfu again and again until the device is in pwned DFU mode !"
    ./ipwndfu -p
    check=$(../files/lsusb | grep -c "checkm8")
done

sleep 1
echo "Patching signature checks"

if [ "$device" == "iPhone10,3" ] || [ "$device" == "iPhone10,6" ]
then
    ./ipwndfu --patch
    sleep 0.1
else
    python rmsigchks.py
    sleep 1
fi

echo "Device is now in pwned DFU mode with signature checks removed (Thanks to Linus Henze & akayn)"
echo "Entering PWNREC mode"
cd ..
cd files

if [ "$device" == "iPhone10,3" ] || [ "$device" == "iPhone10,6" ]; then
    ./irecovery -f junk.txt
fi

./irecovery -f ibss.$device.img4

if [ "$device" == "iPhone6,1" ] || [ "$device" == "iPhone6,2" ]; then
    ./irecovery -f ibec.$device.img4
fi

if [ "$device" == "iPad4,1" ] || [ "$device" == "iPad4,2" ] || [ "$device" == "iPad4,3" ] || [ "$device" == "iPad4,4" ] || [ "$device" == "iPad4,5" ] || [ "$device" == "iPad4,6" ] || [ "$device" == "iPad4,7" ] || [ "$device" == "iPad4,8" ] || [ "$device" == "iPad4,9" ]; then
    ./irecovery -f ibec.$device.img4
fi

echo "Entered PWNREC mode"
sleep 4
echo "Current nonce"
./irecovery -q | grep "NONC"
echo "Setting nonce to $generator"
./irecovery -c "setenv com.apple.System.boot-nonce $generator"
sleep 1
./irecovery -c "saveenv"
sleep 1
./irecovery -c "setenv auto-boot false"
sleep 1
./irecovery -c "saveenv"
sleep 1
./irecovery -c "reset"
echo "Waiting for device to restart into recovery mode"
sleep 7
echo "New nonce"
./irecovery -q | grep "NONC"

echo "Done setting SHSH nonce to device"
echo ""
echo "futurerestore can now restore to the firmware that SHSH is vaild for!"
echo "Assuming that signed SEP and Baseband are compatible!"
