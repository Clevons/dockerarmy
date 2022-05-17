#!/usr/bin/env bash

# Please fill out config.sh file to set up variables
# sourcing variables from config.sh
if test -f config.sh; then
    source config.sh
else
    echo "########################################################################"
    echo "No config found. Please place config.sh in the same folder as the script"
    echo "########################################################################"
    exit 1
fi

# checks for user specified IPtables
echo "Do you want to use system Iptables [system]"
echo "Do you want to use Iptables config file [file]"
echo "You have no idea, just make it work [script]"
read -r -p "[system/file/script]" input

case $input in
	[system])
		echo "#########################"
		echo "leaving iptables as is..."
		echo "#########################"
		;;
	[file])
	
		if test -f "iptables.sh"; then 
    			
     			echo "###############################################"
    			echo "   Sourcing iptables.sh for iptables Rules     "
    			echo "###############################################"
    			source iptables.sh  			
		else
    			echo "###############################################"
    			echo "no iptables.sh specified, will use system rules"
    			echo "###############################################"
    		fi
    	;;
    	[script])
    		iptables=false
    	;;
    	*)
    		echo "Invalid input... will use system rules"
		;;
esac


# Building Docker image from Dockerfile
sudo docker build $dockerpath -f $dockerfile -t dockerarmy

# Creating virtual interfaces for specified range of IPs
for i in $( seq $ipstart $ipend ); do
     
     sudo ifconfig $interface:$i $iprange.$i netmask 255.255.255.0 up
     
done

# Running Docker images for specified number of IPs and port
for i in $( seq $ipstart $ipend ); do

     sudo docker run -dit -p $iprange.$i:$dockerport:$dockerport dockerarmy:latest

done

if (( $iptables == false )); then
  # Allow interdocker and interdocker traffic and Allow outside traffic to Docker instance 
  #clear all Iptables rules:
    sudo iptables -F

  # Create new firewall rules:
    sudo iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
    sudo iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
    sudo iptables -A INPUT -i lo -j ACCEPT
    sudo iptables -A FORWARD -i lo -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport $dockerport -j ACCEPT
    sudo iptables -A FORWARD -p tcp --dport $dockerport -j ACCEPT
    sudo iptables -A INPUT -i docker0 -j ACCEPT
    sudo iptables -A FORWARD -i docker0 -j ACCEPT
    sudo iptables -A FORWARD -j DROP
    sudo iptables -P INPUT DROP
fi
