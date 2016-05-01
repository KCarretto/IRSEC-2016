#!/bin/bash

echo "DON'T FORGET TO RE-RUN YOUR FIREWALL SCRIPT!!!!"

iptables -I OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -I OUTPUT -p tcp --dport 443 -j ACCEPT
iptables -I OUTPUT -p udp --dport 53 -j ACCEPT

iptables -I INPUT -p tcp --sport 80 -j ACCEPT
iptables -I INPUT -p tcp --sport 443 -j ACCEPT
iptables -I INPUT -p udp --sport 53 -j ACCEPT

echo "Rules applied... you are vulnerable right now DX hurry up!"
