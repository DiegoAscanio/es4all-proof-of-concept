# ES4ALL Proof of Concept

This repository contains a Dockerfile describing a Docker image hosting three qemu virtual machines that brings ES4ALL to life.

Unfortunately github does not support huge files, so the qcow2 images and windows-10-enterprise custom unattend iso are not included in this repository.

The VMs hosted when you run a container from this image are:

- ES4ALL Containers VM — A virtual machine that hosts a docker composition with all the services necessary to bring a ES4ALL Samba AD/DC up and running, with a user self-registration django application service.
- Windows 10 VM - A virtual machine that is created on the fly (altough it takes a considerable amount of time) everytime ES4ALL proof-of-concept is run, through a custom unattend iso that installs Windows 10 Enterprise and joins the ES4ALL Samba AD/DC without any user interaction. Why this approach? Because Windows 10 Enterprise is the only Windows 10 evaluation version available and gives you 90 days to test it. For demonstration and non-commercial purposes, anyone is allowed to use it, therefore no intelectual property from Microsoft is being violated.
- User self registration VM - A virtual machine with a simple X11 and a mini browser instance that loads the user self-registration django application service hosted on the ES4ALL Containers VM automatically where you can register users to the ES4ALL Samba AD/DC and test their login on the Windows 10 VM.

Pre-requisites to run this proof of concept:

- A Fedora, Ubuntu or Arch Linux host.

How to run it?

1. Download the start-proof-of-concept.sh script from this repository as it follows:

```bash
curl -O https://raw.githubusercontent.com/ES4ALL/proof-of-concept/main/start-proof-of-concept.sh
```
