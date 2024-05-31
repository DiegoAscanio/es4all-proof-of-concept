#!/bin/bash
HDD_PATH=$1

qemu-system-i386 \
-m 512 \
-netdev tap,id=mynet2,ifname=tap2,script=no,downscript=no \
-device e1000,netdev=mynet2,mac=52:54:00:56:43:21 \
-hda $HDD_PATH \
-name "ES4ALL User Registration" \
-enable-kvm
