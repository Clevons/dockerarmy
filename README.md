# Dockerarmy
script to spin up multipe dockerinstance on multiple virtual interfaces

## Usage

1. download config.sh and startDockerAmy.sh

2. fill out config.sh config parameters to suit your docker container and usecase

3. the script will ask wether to use system iptables or iptables included in the script
   the rules included in the script are made for hosting CTF's, so they will allow outside traffic to docker instances.
