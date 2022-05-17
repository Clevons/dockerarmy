# Dockerarmy
script to spin up multipe dockerinstance on multiple virtual interfaces

## Usage

1. download config.sh and startDockerAmy.sh

2. fill out config.sh config parameters to suit your docker container and usecase

3. the script will ask wether to use system iptables or iptables included in the script
   the rules included in the script are made for hosting CTF's, so they will allow outside traffic to docker instances.
   
## Config parameters:

IP Range: 
The following 3 parameters will spin up a range of 10 containers
ranging from 192.168.8.10 to 192.168.8.20 on virtual interfaces from eth0:10-eth0:20
with port 1060 exposed to the container

``` iprange=192.168.8 ```
sets the first 3 octets the docker army iprange

```ipstart=10```
set the start ip for dockerarmy

```ipend=20```
sets the end ip for dockerarmy

```interface=eth0```
Specifies the interface you want to split into virtual interfaces

```dockerpath=/path/to/dockerfile/```
path to your dockerfiles, must end with /

```dockerfile=Dockerfile```
name of the dockerfile specified

```dockerport=1060```
port to expose internally and externally
