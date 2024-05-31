#!/bin/bash

# 1. Find which distro we are running and exit if it ain't Ubuntu, Fedora or Arch Linux. We also define the package update and installation command for each distro.

if [ -f /etc/os-release ]; then
    . /etc/os-release
    case $ID in
        ubuntu)
            update="sudo apt update"
            install="sudo apt install -y"
            ;;
        fedora)
            update="sudo dnf check-update"
            install="sudo dnf install -y"
            ;;
        arch)
            update="sudo pacman -Sy"
            install="sudo pacman -S --noconfirm"
            ;;
        *)
            echo "Unsupported distro. Exiting."
            exit 1
            ;;
    esac
else
    echo "Unsupported distro. Exiting."
    exit 1
fi

# 2. Update the package list
$update

# 3. Install docker if and only if it is not already installed
if ! command -v docker &> /dev/null; then
    $install docker
    sudo systemctl enable docker
    sudo systemctl start docker
    # Add the current user to the docker group so that we don't have to use sudo to run docker commands
    sudo usermod -aG docker $USER
    newgrp docker
fi

# 4. Install xhost if and only if it is not already installed
if ! command -v xhost &> /dev/null; then
    case $ID in
        ubuntu)
            $install x11-xserver-utils
            ;;
        fedora)
            $install xorg-x11-server-utils
            ;;
        arch)
            $install xorg-xhost
            ;;
    esac
fi

# 5. Enable X11 forwarding
xhost +

# 6. Load KVM modules
sudo modprobe kvm
# Load intel module if it is an Intel CPU
if [ -f /proc/cpuinfo ]; then
    if grep -q "Intel" /proc/cpuinfo; then
        sudo modprobe kvm-intel
    fi
fi
# 7. Load AMD module if it is an AMD CPU
if [ -f /proc/cpuinfo ]; then
    if grep -q "AMD" /proc/cpuinfo; then
        sudo modprobe kvm-amd
    fi
fi

# 8. Run the docker container
docker run --privileged -d -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY diegoascanio/cefetmg:proof-of-concept
