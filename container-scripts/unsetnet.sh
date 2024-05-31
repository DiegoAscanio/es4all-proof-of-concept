#!/bin/bash

# 1. Request root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# 2. Delete all TAP interfaces
for tap in $(ip link show | grep -o 'tap[0-9]*'); do
  ip link set $tap down
  ip link delete $tap
done

# 3. Delete the bridge interface
if ip link show br0 &> /dev/null; then
  ip link set br0 down
  ip link delete br0
fi

# 4. Flush iptables rules
iptables -F
iptables -t nat -F
iptables -t mangle -F
iptables -t raw -F
iptables -X
iptables -t nat -X
iptables -t mangle -X
iptables -t raw -X

echo "All TAP interfaces, bridge, and iptables rules have been cleaned up."

# 5. Enable iptables for bridged traffic
sysctl -w net.bridge.bridge-nf-call-iptables=1
