#!/bin/bash
# Marc Levine

#

if [ $# -eq 1 ]; then
IPRange=$1
echo -n "Please enter your log file name: "
read logfile
elif [ $# -eq 2 ]; then
    IPRange=$1
    logfile=$2
else
        echo "Please enter the IP range in slash notation ex:10.0.0.0/24"
        echo -n "CIDR Notation: " #the echo -n will write without a newline
        read IPRange
        echo -n "Please enter your log file name: "
        read logfile
fi
echo "Please sit back and relalx while this script runs"

function randDNS {
    case $1 in
        1)
            dns="8.8.8.8"
        ;;
        2)
            dns="8.8.4.4"
        ;;
        3)
            dns="209.244.0.4"

        ;;
        4)
            dns="209.244.0.3"

        ;;
    esac

}

#check hosts to see if they are live using nmap

ipString=`nmap $IPRange -n -sP | grep report | awk '{print $5}'`

read -a ipArray <<<$ipString

for ipHost in "${ipArray[@]}"
do
echo "Checking IP Address:" $ipHost

#generate random number to change dns server
rand=`echo $RANDOM % 4 + 1 | bc`
randDNS $rand
#echo dig @$dns +short -x  $ipHost
hostName=`dig @$dns +short -x  $ipHost`
unset -v dns
#output to file
echo "$ipHost,$hostName" >> "$logfile"
done
