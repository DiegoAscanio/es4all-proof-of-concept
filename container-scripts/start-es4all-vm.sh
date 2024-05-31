#!/bin/bash
HDD_PATH=$1

qemu-system-i386 \
-m 1024 \
-netdev tap,id=mynet0,ifname=tap0,script=no,downscript=no \
-device e1000,netdev=mynet0,mac=52:54:00:12:34:56 \
-hda $HDD_PATH \
-name "ES4ALL Containers" \
-enable-kvm
