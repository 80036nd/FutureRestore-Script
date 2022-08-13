#!/bin/bash
echo "Please drag and drop IPSW file into terminal:"
read ipsw
./futurerestore -t blob.shsh2 --latest-sep --latest-baseband -d $ipsw
clear
echo "Device Should be Restored"
echo "FutureRestore-Script By 80036nd"

