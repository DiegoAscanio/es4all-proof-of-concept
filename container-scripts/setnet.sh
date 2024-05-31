#!/bin/bash

# 1. Request root privileges
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# 2. Set bridge interface
ip link add name br0 type bridge
ip link set up dev br0


# 3. Set tap interfaces through the number received as an argument
#    default number is 3
if [ ! -z "$1" ]; then
    TAP_NUM=$(expr $1 - 1)
else
  TAP_NUM=2
fi
for i in $(seq 0 $TAP_NUM); do
  ip tuntap add dev tap$i mode tap user 1000
  ip link set up dev tap$i
done

# 4. Add tap interfaces to the bridge
for i in $(seq 0 $TAP_NUM); do
  ip link set tap$i master br0
done

# 5. Set IP address for the bridge received as an argument
#   default address is 192.168.200.1/24
if [ ! -z "$2" ]; then
  ip addr add $2 dev br0
else
  ip addr add 192.168.200.1/24 dev br0
fi

# 6. Enable IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

# 7. Enable NAT for the brigde and output interface received as an argument
#    default output interface is wlan0
if [ ! -z "$3" ]; then
    OUT_IF=$3
else
    OUT_IF=$(ip route | grep default | awk '{print $5}')
fi
iptables -t nat -A POSTROUTING -o $OUT_IF -j MASQUERADE

# 8. Add forwarding rules
iptables -A FORWARD -i br0 -o $OUT_IF -j ACCEPT
iptables -A FORWARD -i $OUT_IF -o br0 -m state --state RELATED,ESTABLISHED -j ACCEPT

# 8. Allow forwarding between tap interfaces
for i in $(seq 0 $TAP_NUM); do
  for j in $(seq 0 $TAP_NUM); do
    if [ $i -ne $j ]; then
      iptables -A FORWARD -i tap$i -o tap$j -j ACCEPT
      iptables -A FORWARD -i tap$j -o tap$i -j ACCEPT
    fi
  done
done

# 9. Disable iptables for bridged traffic
sysctl -w net.bridge.bridge-nf-call-iptables=0
