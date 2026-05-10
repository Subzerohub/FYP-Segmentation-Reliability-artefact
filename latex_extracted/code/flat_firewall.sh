#!/bin/bash

iptables -F
iptables -P FORWARD DROP

iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Internal network can go out.
iptables -A FORWARD -s 10.10.0.0/24 -j ACCEPT

# External attacker can only reach public web server.
iptables -A FORWARD -s 192.168.100.0/24 -d 10.10.0.40 -p tcp --dport 80 -j ACCEPT

# External attacker cannot reach other internal systems.
iptables -A FORWARD -s 192.168.100.0/24 -d 10.10.0.0/24 -j DROP

echo "Flat firewall rules loaded"
