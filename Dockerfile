FROM alpine:latest

# Copy qcow2 images to /VMs
COPY harddrives/es4all.qcow2 /VMs/es4all.qcow2
COPY harddrives/windows.qcow2 /VMs/windows.qcow2
COPY harddrives/user-registration.qcow2 /VMs/user-registration.qcow2

# Copy Windows 10 ISO to /ISOs
COPY OS-installation-files/10-unattend.iso /ISOs/10-unattend.iso

# Copy container-scripts to /scripts
COPY container-scripts/* /scripts/

# Install required packages
RUN source /etc/profile && \
    apk update && \
    apk add --no-cache \
    qemu-system-i386 \
    qemu-img \
    qemu-ui-gtk \
    qemu-ui-sdl \
    bridge-utils \
    iptables \
    alpine-conf \
    bash \
    iproute2 \
    xf86-video-vesa

# Install fonts
RUN apk add font-terminus font-inconsolata font-dejavu font-noto font-noto-cjk font-awesome font-noto-extra

# Setup X11
RUN source /etc/profile && \
    setup-xorg-base || true

# Entrypoint
ENTRYPOINT ["/scripts/entrypoint.sh"]

# Default command
CMD ["/bin/bash"]
