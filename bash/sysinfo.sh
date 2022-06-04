#! /bin/bash
#Lab2 Challenge Script
#Mark Berwick Student ID: 020004248


#Gathering the hostname and the removing eveything after the . to create a simple hostname and then putting
#that into a variable named domain
domain=$(hostname -A | cut -d "." -f1)

#Gathering the full hostname and putting it into a variable named FullDomain
FullDomain=$(hostname -A)

#Gathering the IP address that my computer uses to connect to the internet and putting it into
#a variable named ip
ip=$(hostname -I)

#Gathering the main file system that my Linux is  using, searching for the word sda3 and then gathering 
#the words from the 4th column and then storing that in a variable named file
file=$(df -h | grep -w sda3 | awk '{print $4}' )

#Using cat to look at what is in /etc/os-release for info on the OS on my system
#then looking for the word pretty (incase sensitive) and then gathering the data from the 
#second column and then finally putting that in a variable named os
os=$(cat /etc/os-release | grep -i pretty | awk -F'"' '{print $2}')


#Template using cat where only variables are called to fill in the data parts of the output
cat << EOF
Report for $domain
=================
FQDN: $FullDomain
Operating System name and version: $os
IP Address: $ip 
Root Filesystem Free Space: $file 
=================

EOF
