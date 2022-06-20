#! /bin/bash

echo "Checking to see whether LXD is currently installed..."
checkLxd=$(lxd --version)






#if there is a version of lxd found, let the user know
#otherwise let the user know lxd is not installed and that it will be installed now
if [ "$?" = 0 ] ; then
	echo "LXD found. Current version of lxd installed is $checkLxd"
else
	echo "lxd is not yet installed. Installing now."
	sudo apt install snapd -y  #Checks to see whether snap is installed as we need that to install lxd
	sudo snap install lxd

fi

#initialize lxd
sudo lxd init --auto


#checking to see what version of operating system is being run on this machine
#we will use that version of Linux as the server to be placed in the lxd container
#shortly
os=$(cat /etc/os-release | grep -i pretty | awk -F'"' '{print $2}')


#creating a variable to house  the name of the container COMP2101-S22 
#to check and see if it is already running later in the script
lxcList=$(lxc list | grep -w "COMP2101-S22" | awk -F' ' '{print $2}')


#check to see whether there is already a container called COMP2101-S22
#if there is, then there is no need to download and install Ubuntu and user will be 
#notified they already have a container running named COMP2101-S22
#if there isn't, user will be notified and download and install will commence
#container will then be created with the name COMP2101-S22 with the version of 
#linux found in $os variable

if [ "$lxcList" = COMP2101-S22 ] ; then
	echo "There is a container called COMP2101-S22"

else
	echo "No container named COMP2101-S22 was found. $os will be downloaded and installed and a container called COMP2101-S22 will be created to house it."
	lxc launch ubuntu:22.04 COMP2101-S22
fi


#checking to see whether we can find apache2 install status and putting it in a variable named $apache2
apache2=$(dpkg --get-selections | grep apache2)


#Checking to see whether apache2 is installed by looking to see if there is a string present
#in the $apache2 variable created earlier
#download and install apache2 to the COMP2101-S22 container if apache2 not found and inform the user
#or inform the user if apache2 is already installed
if [[ -z "$apache2" ]] ; then
	echo "Checking Apache2 status: ..."
	echo "Apache2 is not yet installed. Installing now!"
	sudo lxc exec COMP2101-S22 -- apt-get update
	sudo lxc exec COMP2101-S22 -- apt-get install apache2 -y
else
	echo "Checking Apache2 status: ..."
	echo "Apache2 is already installed."

fi



#get the default web page from the apache2 webserver that was installed
lxc exec COMP2101-S22 -- curl http://127.0.0.1


#let the user know whether the script was successful in getting the default Apache2 webpage.
if [ "$?" = 0 ] ; then
	echo "Successfully retrieved default apache2 web page!"
else
	echo "Script was not able to retrieve the Apache2 default web page."
fi
