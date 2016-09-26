#!/bin/bash

gongsi_ip=`ping -c 1 ddns.fdcq.net|grep PING|cut -d' ' -f 3`

if [ $? -le 1 ]
then
    ip=${gongsi_ip//[()]/}
    white_list=`fgrep sshd /etc/hosts.allow`

    if [ ${white_list} != "sshd:${ip},120.26.74.176:allow" ]
    then
    sed -i "s/sshd:.*:allow$/sshd:${ip},120.26.74.176:allow/g" /etc/hosts.allow

#    iptables -N MYSQLPROXY
#    iptables -A INPUT -p tcp --dport 4040 -j MYSQLPROXY

#    iptables -F MYSQLPROXY
#    iptables -I MYSQLPROXY -s 120.26.74.176 -j ACCEPT
#    iptables -I MYSQLPROXY -s 120.132.53.231 -j ACCEPT
#    iptables -I MYSQLPROXY -s 120.27.150.11 -j ACCEPT
#    iptables -I MYSQLPROXY -s 120.132.53.211 -j ACCEPT
#    iptables -I MYSQLPROXY -s ${ip} -j ACCEPT
#    iptables -A MYSQLPROXY -j DROP

#    iptables -F SSHWHITE
#    iptables -I SSHWHITE -s ${ip} -j ACCEPT
#    iptables -I SSHWHITE -s 120.26.74.176 -j ACCEPT
#    iptables -A SSHWHITE -j DROP

#    iptables -F SUPERWHITE
#    iptables -I SUPERWHITE -s ${ip} -j ACCEPT
#    iptables -I SUPERWHITE -s 120.26.74.176 -j ACCEPT
    fi
fi

