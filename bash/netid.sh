#!/bin/bash
#
# this script displays some host identification information for a Linux machine
#
# Sample output:
#   Hostname      : zubu
#   LAN Address   : 192.168.2.2
#   LAN Name      : net2-linux
#   External IP   : 1.2.3.4
#   External Name : some.name.from.our.isp

# the LAN info in this script uses a hardcoded interface name of "eno1"
#    - change eno1 to whatever interface you have and want to gather info about in order to test the script

# TASK 1: Accept options on the command line for verbose mode and an interface name - must use the while loop and case command as shown in the lesson - getopts not acceptable for this task
#         If the user includes the option -v on the command line, set the variable $verbose to contain the string "yes"
#            e.g. network-config-expanded.sh -v
#         If the user includes one and only one string on the command line without any option letter in front of it, only show information for that interface
#            e.g. network-config-expanded.sh ens34
#         Your script must allow the user to specify both verbose mode and an interface name if they want
# TASK 2: Dynamically identify the list of interface names for the computer running the script, and use a for loop to generate the report for every interface except
# loopback - do not include loopback network information in your output

################
# Data Gathering
################
# the first part is run once to get information about the host
# grep is used to filter ip command output so we don't have extra junk in our output
# stream editing with sed and awk are used to extract only the data we want displayed



#create the array which first gathers all interfaces, captures only the first column of the results, removes the header and then removes the last line which is the loopback
#we'll use this a little later depending on what the user selects at the command line
intArray=( $(nmcli device status | awk '{print $1}' | awk '(NR>1)' | head -n -1) )





#While loop that monitors the command line for input from the user. Includes -h for help, -v for verbose mode, -n for hostname, and a wildcard for whatever the user enters
#such as an interface name
while [ $# -gt 0 ]; do
        case "$1" in
        -h | --help)
                echo "Usage: $(basename $0) [-h|--help for help, -v for verbose mode, -i for interface name, -a for more information on all interfaces, -? to see list of interfaces to choose from]"
                exit
                ;;
        -v)
                echo "Verbose mode activated for $(basename $0)"
               # [ "$verbose" = "yes" ]
		verbose="yes"
               # set -x
                ;;
        -n)
                echo "The host name is $(hostname)"
                ;;

	-a)
		#Interface reports for interfaces found on this system (made it green so it stood out a bit)
		echo "========================="
		echo -e "\e[1;32m The script will now run a report on each interface found on this system!\e[1;m"

		#For Loop that will generate a report on each interface found except the loopback
		for n in ${intArray[@]};
		do
        		ifconfig $n
		done
		echo "========================="
		echo ""
		exit 0
		;;



        -?)
                #The following piped commands will together list what interfaces were found on the system so the user can enter which one they want the report on.
                echo "========================="
                echo "NetID scanned your system and found the following interfacesyou can run with netid.sh [your interface choice]:"
                nmcli device status | awk '{print $1}' | awk '(NR>1)' | head -n -1
                echo "========================="
                echo ""
               # echo -e "Your input was\e[1;31m $filename\e[1;m"
                echo ""
                exit 0
                ;;




        *)
                filename+=("$1")
		echo -e "Your input was\e[1;31m $filename\e[1;m"
                #echo "${filename[0]}"
                #ifconfig $filename
                ;;



        #*)
                #echo "Argument not recognized: '$1'"
                #exit 1
                #;;
        esac
        shift
done





#The following command is just here for my testing so I can check and see what is in $filename when I need to:
#echo $filename






#####
# Once per host report
#####
[ "$verbose" = "yes" ] && echo "Gathering host information..."
# we use the hostname command to get our system name and main ip address
my_hostname="$(hostname) / $(hostname -I)"

[ "$verbose" = "yes" ] && echo "Identifying default route..."
# the default route can be found in the route table normally
# the router name is obtained with getent
default_router_address=$(ip r s default| awk '{print $3}')
default_router_name=$(getent hosts $default_router_address|awk '{print $2}')

[ "$verbose" = "yes" ] && echo "Checking for external IP address and hostname..."
# finding external information relies on curl being installed and relies on live internet connection
external_address=$(curl -s icanhazip.com)
external_name=$(getent hosts $external_address | awk '{print $2}')

#Echo for putting a little blank space between outputs to make things a little easier to read
echo ""


#create the array which first lists all interfaces, captures only the first column, removes the header and then removes the last line which is the loopback
#intArray=( $(nmcli device status | awk '{print $1}' | awk '(NR>1)' | head -n -1) )




#Can use the following declare command to list what the array contains but it looks messy and the user
#might not know what it all means so I commented it out
#but left it in in case I need it later:
#declare -p intArray

#Interface reports for interfaces found on this system (made it green so it stood out a bit)
#echo "========================="
#echo -e "\e[1;32m The script will now run a report on each interface found on this system!\e[1;m"

#For Loop that will generate a report on each interface found except the loopback
#for n in ${intArray[@]};
#do
#	ifconfig $n
#done
#echo "========================="
#echo ""





cat <<EOF

System Identification Summary
=============================
Hostname      : $my_hostname
Default Router: $default_router_address
Router Name   : $default_router_name
External IP   : $external_address
External Name : $external_name

EOF

#####
# End of Once per host report
#####

# the second part of the output generates a per-interface report
# the task is to change this from something that runs once using a fixed value for the interface name to
#   a dynamic list obtained by parsing the interface names out of a network info command like "ip"
#   and using a loop to run this info gathering section for every interface found

# the default version uses a fixed name and puts it in a variable
#####
# Per-interface report
#####

# define the interface being summarized
#interface="enp0s3"


#interface="$intArray"



#if $filename=""; then
#for interface in $intArray; do
#for interface in ${intArray[3]}; do
for interface in $filename; do



[ "$verbose" = "yes" ] && echo "Reporting on interface(s): $interface"

[ "$verbose" = "yes" ] && echo "Getting IPV4 address and name for interface $interface"
# Find an address and hostname for the interface being summarized
# we are assuming there is only one IPV4 address assigned to this interface
ipv4_address=$(ip a s $interface|awk -F '[/ ]+' '/inet /{print $3}')
ipv4_hostname=$(getent hosts $ipv4_address | awk '{print $2}')

[ "$verbose" = "yes" ] && echo "Getting IPV4 network block info and name for interface $interface"
# Identify the network number for this interface and its name if it has one
# Some organizations have enough networks that it makes sense to name them just like how we name hosts
# To ensure your network numbers have names, add them to your /etc/networks file, one network to a line, as   networkname networknumber
#   e.g. grep -q mynetworknumber /etc/networks || (echo 'mynetworkname mynetworknumber' |sudo tee -a /etc/networks)
network_address=$(ip route list dev $interface scope link|cut -d ' ' -f 1)
network_number=$(cut -d / -f 1 <<<"$network_address")
network_name=$(getent networks $network_number|awk '{print $1}')

cat <<EOF

Interface $interface:
===============
Address         : $ipv4_address
Name            : $ipv4_hostname
Network Address : $network_address
Network Name    : $network_name

EOF

#####
# End of per-interface report
#####
done

