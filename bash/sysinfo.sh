#!/bin/bash
#Lab 1 Challenge Script
#Mark Berwick Student ID: 020004248

#echo with no arguements to add a blank line for readability
echo



#Gathering and displaying the hostname
echo "Hostname:     "$HOSTNAME

#echo with no arguements to add a blank line for readability
echo


#Gathering and displaying the system DNS domain name 
echo -n "Domain Name:       " 
	hostname -A 

#echo with no arguements to add a blank line for readability
echo


#cat to display the contents of os-release, grep to find the line
#we're looking for, awk to use a delimiter and separate what we need which
#is then printed
echo -n "Operating System and version:       "
	cat /etc/os-release | grep -i pretty | awk -F'"' '{print $2}'


#echo with no arguements to add a blank line for readability
echo


#Gather and display the primary ip address
echo -n "IP Addresses:       "
	hostname -I


#Gather and display the IPv6 address and we separate just the ip from the
#rest of the line using grep to find the word inet6 and then awk with
#a space delimiter to find the ip in the line and then print it
echo -n "IPv6 Address:       "
	/sbin/ip -6 addr show dev enp0s3 | grep -w inet6 | awk -F' ' '{print $2}'


#echo with no arguements to add a blank line for readability
echo

#Gathering the header line and the main filesystem where Ubuntu is stored
#and running
echo "Root File System Status:"
df -h | grep -w Filesystem
df -h | grep -w sda3

#echo with no arguements to add a blank line for readability
echo
