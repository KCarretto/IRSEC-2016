#!/bin/bash

#Created by Kyle Carretto 2016 - IRSec 2016

iptables -F
iptables -X

iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT

iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT

iptables -A INPUT -p tcp --dport 80 -j ACCEPT	                #Allow web to be served

iptables -A OUTPUT -p tcp --dport 3306 --dst X.X.X.X -j ACCEPT	#Allow to sql server
iptables -A INPUT -p tcp --sport 3306 --src X.X.X.X -j ACCEPT   #Allow from sql server

iptables -A INPUT -j DROP
iptables -A OUTPUT -j DROP


