# ES4ALL Proof of Concept

This repository contains a Dockerfile describing a Docker image hosting three qemu virtual machines that brings ES4ALL to life.

Unfortunately github does not support huge files, so the qcow2 images and windows-10-enterprise custom unattend iso are not included in this repository.

The VMs hosted when you run a container from this image are:

- ES4ALL Containers VM — A virtual machine that hosts a docker composition with all the services necessary to bring a ES4ALL Samba AD/DC up and running, with a user self-registration django application service.
- Windows 10 VM - A virtual machine that is created on the fly (altough it takes a considerable amount of time) everytime ES4ALL proof-of-concept is run, through a custom unattend iso that installs Windows 10 Enterprise and joins the ES4ALL Samba AD/DC without any user interaction. Why this approach? Because Windows 10 Enterprise is the only Windows 10 evaluation version available and gives you 90 days to test it. For demonstration and non-commercial purposes, anyone is allowed to use it, therefore no intelectual property from Microsoft is being violated.
- User self registration VM - A virtual machine with a simple X11 and a mini browser instance that loads the user self-registration django application service hosted on the ES4ALL Containers VM automatically where you can register users to the ES4ALL Samba AD/DC and test their login on the Windows 10 VM.

Pre-requisites to run this proof of concept:

- A Fedora, Ubuntu or Arch Linux host.
- A cpu that supports hardware virtualization and at least 4 cores.
- At least 8Gb of RAM.

How to run it?

1. Download the start-proof-of-concept.sh script from this repository as it follows:

```bash
curl -O https://raw.githubusercontent.com/DiegoAscanio/es4all-proof-of-concept/main/start-proof-of-concept.sh
```

2. Make the script executable:

```bash
chmod +x start-proof-of-concept.sh
```

3. Run the script:

```bash
./start-proof-of-concept.sh
```

And that's it, the script will run some commands at sudo, such as installing docker, docker-compose and xhost if you don't have them installed, and then, it will run a container (that will be removed when you stop it) with the ES4ALL proof of concept image hosted at Docker Hub.

If you already have docker and docker-compose installed but your user is not in the docker group, you should add it to the docker group and re-login to your session, so you can run docker privileged commands without sudo, as it follows:

```bash
sudo usermod -aG docker $(whoami)
```

Then perform a logout and login again. Why this is necessary? The Windows VM (and the others) needs to access the host's CPU in order to run and this requires the flag -enable-kvm to be passed as a parameter to the qemu command, which is only possible if you run the container with the --privileged flag that requires your user to be in the docker group.

For this reason, your host should support hardware virtualization that is enabled in your BIOS/UEFI settings. If you don't have this feature enabled, you can't run this proof of concept. Check how to enable it in your hardware's manual or in the internet. Some references to help you with this:

- [How to enable virtualization in your PC BIOS](https://www.howtogeek.com/213795/how-to-enable-intel-vt-x-in-your-computers-bios-or-uefi-firmware/)
- [How to Enable Virtualization (Hypervisor) in BIOS/UEFI](https://www.isumsoft.com/computer/enable-virtualization-technology-vt-x-in-bios-or-uefi.html)

Lastly but not least, you should take a cup of coffee and wait for the container image download (it's about 12Gb) and the VMs to be created. The Windows VM creation takes a considerable amount of time, as it is installing Windows 10 Enterprise from scratch, so be patient.

## Video tutorial showing how to run this proof of concept

![https://i.imgur.com/fu09cry.png](https://www.youtube.com/watch?v=5mjIi7k6w9o)
