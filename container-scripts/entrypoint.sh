#!/bin/bash

# Load the environment variables
export $(cat /scripts/envvars | xargs)

# setup the network
exec /scripts/setnet.sh &

# start es4all VM
exec /scripts/start-es4all-vm.sh /VMs/es4all.qcow2 &

# wait 30s
sleep 30

# start the windows VM
exec /scripts/start-unattended-windows-10.sh /VMs/windows.qcow2 /ISOs/10-unattend.iso &

# wait 60s
sleep 60

# start the user registration VM
exec /scripts/start-user-registration.sh /VMs/user-registration.qcow2
