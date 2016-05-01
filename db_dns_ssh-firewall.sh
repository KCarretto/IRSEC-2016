#!/bin/bash

iptables -F
iptables -X

#while [ 1 ]
#do


iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT

iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT

iptables -A INPUT -p tcp --dport 3306 -m iprange --src-range 10.10.1.40-10.10.1.40 -j ACCEPT	#Allow from a sql server
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -j ACCEPT

iptables -A INPUT -j DROP
iptables -A OUTPUT -j DROP

#done
