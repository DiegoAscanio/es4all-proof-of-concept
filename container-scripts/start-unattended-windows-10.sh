#!/bin/bash

WINDOWS_HDD_PATH=$1
WINDOWS_ISO_PATH=$2
USB_DONGLE_PATH=$3

qemu-system-i386 \
    -m 1024 \
    -netdev tap,id=mynet1,ifname=tap1,script=no,downscript=no \
    -device rtl8139,netdev=mynet1,mac=52:54:00:12:28:57 \
    -hda $WINDOWS_HDD_PATH \
    -cdrom $WINDOWS_ISO_PATH \
    -boot menu=on \
    -name "Windows 10" \
    -enable-kvm \
    -machine type=q35 \
    -cpu host,hv-relaxed,hv-vapic,hv-spinlocks=0x1fff,hv-time
