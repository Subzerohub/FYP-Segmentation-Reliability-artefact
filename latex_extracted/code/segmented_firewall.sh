#!/bin/bash

iptables -F
iptables -P FORWARD DROP

iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# External attacker can only reach public web server.
iptables -A FORWARD -s 192.168.200.0/24 -d 10.10.40.10 -p tcp --dport 80 -j ACCEPT

# Students can only reach web.
iptables -A FORWARD -s 10.10.10.0/24 -d 10.10.40.10 -p tcp --dport 80 -j ACCEPT

# Staff can reach web and file server.
iptables -A FORWARD -s 10.10.20.0/24 -d 10.10.40.10 -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -s 10.10.20.0/24 -d 10.10.40.20 -p tcp --dport 445 -j ACCEPT

# Admin can reach web, file server, and database.
iptables -A FORWARD -s 10.10.30.0/24 -d 10.10.40.10 -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -s 10.10.30.0/24 -d 10.10.40.20 -p tcp --dport 445 -j ACCEPT
iptables -A FORWARD -s 10.10.30.0/24 -d 10.10.40.30 -p tcp --dport 3306 -j ACCEPT

# IoT can only reach web.
iptables -A FORWARD -s 10.10.50.0/24 -d 10.10.40.10 -p tcp --dport 80 -j ACCEPT

# Guest can only reach web.
iptables -A FORWARD -s 10.10.60.0/24 -d 10.10.40.10 -p tcp --dport 80 -j ACCEPT

echo "Segmented firewall rules loaded"
