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

# TASK 1: Accept options on the command line for verbose mode and an interface name
#         If the user includes the option -v on the command line, set the varaible $verbose to contain the string "yes"
#            e.g. network-config-expanded.sh -v
#         If the user includes one and only one string on the command line without any option letter in front of it, only show information for that interface
#            e.g. network-config-expanded.sh ens34
#         Your script must allow the user to specify both verbose mode and an interface name if they want
# TASK 2: Dynamically identify the list of interface names for the computer running the script, and use a for loop to generate the report for every interface except loopback

#########################
# Initialize Variables #
########################

# setting verbose variable to no and creating empty array for interface name, both can be accepted on the command line.
verbose="no" # verbose - tells the shell to show all lines in a script while they are read, activates verbose mode.
interface_name=""

########################################################################################################################
################################
# Create functions as required #
################################
# if we were to add a help function would probably include this with -h | --help
function usagehelp {
    echo "Usage: $0 [-v] [interface_name]"
}
########################################################################################################################
while [ $# -gt 0 ]; do
  # evaluate the first command on the command line ($!)
  case "$1" in
    -v )
      verbose="yes"
      ;;
      # finished running the -v option
    *)   # else if the user put anything else on the command line
      if [ "$interface_name" != "" ]; then
        echo "Your input is not valid."
        exit 2
      else
        interface_name="$1" # assume it is an interface and add it to array named interface_name
      fi
      ;;
  esac
  shift
done

################
# Data Gathering
################
# the first part is run once to get information about the host
# grep is used to filter ip command output so we don't have extra junk in our output
# stream editing with sed and awk are used to extract only the data we want displayed

#########################
# Once per host report #
########################

[ "$verbose" = "yes" ] && echo "Gathering host information"
# we use the hostname command to get our system name
my_hostname=$(hostname)

[ "$verbose" = "yes" ] && echo "Identifying default route"
# the default route can be found in the route table normally
# the router name is obtained with getent
default_router_address=$(ip r s default| cut -d ' ' -f 3)
default_router_name=$(getent hosts $default_router_address|awk '{print $2}')

[ "$verbose" = "yes" ] && echo "Checking for external IP address and hostname"
# finding external information relies on curl being installed and relies on live internet connection
external_address=$(curl -s icanhazip.com)
external_name=$(getent hosts $external_address | awk '{print $2}')

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
interfaces=()

for interface in $(ip a |awk '/: e/{gsub(/:/,"");print $2}' | sed -e s/@ens34//g); do # identifies all interfaces including vlans (without the @interface which is causing error)
  interfaces+=("$interface") # add each interface to this array
  #echo "${interfaces[@]}" - testing purposes
done

for interface in "${interfaces[@]}"; do   # for each interface in interface array, do the following (if -v included in command line include verbose):

  [ "$verbose" = "yes" ] && echo "Reporting on interface(s): $interface"

  [ "$verbose" = "yes" ] && echo "Getting IPV4 address and name for interface $interface"

  ipv4_address=$(ip a s $interface|awk -F '[/ ]+' '/inet /{print $3}')
  ipv4_hostname=$(getent hosts $ipv4_address | awk '{print $2}')

  [ "$verbose" = "yes" ] && echo "Getting IPV4 network block info and name for interface $interface"
  # Identify the network number for this interface and its name if it has one
  # Some organizations have enough networks that it makes sense to name them just like how we name hosts
  # To ensure your network numbers have names, add them to your /etc/networks file, one network to a line, as   networkname networknumber
  #   e.g. grep -q mynetworknumber /etc/networks || (echo 'mynetworkname mynetworknumber' |sudo tee -a /etc/networks)
  network_address=$(ip route list dev ens34 scope link | awk '{print $1'} | sed 's+/24+''+g')
  # network_number=$(cut -d / -f 1 <<<"$network_address") This was not testing well for me due to the grep command below.
  # ended up adding sed to network_address to get the output I needed to run the rest of the script
  grep -q $network_address /etc/networks || echo "network$interface" "$network_address"|sudo tee -a /etc/networks
  network_name=$(getent networks $network_address|awk '{print $1}')



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
