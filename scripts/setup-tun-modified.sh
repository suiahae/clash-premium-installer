#!/bin/bash


PROXY_BYPASS_USER="root"
PROXY_BYPASS_CGROUP="0x16200000"
PROXY_FWMARK="0x162"
PROXY_ROUTE_TABLE="0x162"
PROXY_DNS_PORT="1053"
PROXY_FORCE_NETADDR="198.18.0.0/16"
PROXY_TUN_DEVICE_NAME="utun"

# echo "---------------------------------------" >> /var/log/tun-up.log

/usr/local/lib/clash/clean-tun.sh

sleep 0.5

/usr/local/lib/clash/setup-cgroup.sh

ipset create localnetwork hash:net
ipset add localnetwork 127.0.0.0/8
ipset add localnetwork 10.0.0.0/8
ipset add localnetwork 192.168.0.0/16
ipset add localnetwork 224.0.0.0/4
ipset add localnetwork 198.18.0.0/16 

ip route replace default dev "$PROXY_TUN_DEVICE_NAME" table "$PROXY_ROUTE_TABLE"

ip rule add fwmark "$PROXY_FWMARK" lookup "$PROXY_ROUTE_TABLE"

iptables -t mangle -N CLASH
iptables -t mangle -F CLASH
iptables -t mangle -A CLASH -m owner --uid-owner "$PROXY_BYPASS_USER" -j RETURN
iptables -t mangle -A CLASH -m owner --uid-owner systemd-timesync -j RETURN
#iptables -t mangle -A CLASH -d "$PROXY_FORCE_NETADDR" -j MARK --set-mark "$PROXY_FWMARK"
iptables -t mangle -A CLASH -m cgroup --cgroup "$PROXY_BYPASS_CGROUP" -j RETURN
iptables -t mangle -A CLASH -m addrtype --dst-type BROADCAST -j RETURN
iptables -t mangle -A CLASH -m set --match-set localnetwork dst -j RETURN
iptables -t mangle -A CLASH -j MARK --set-mark "$PROXY_FWMARK"

iptables -t nat -N CLASH_DNS
iptables -t nat -F CLASH_DNS
iptables -t nat -A CLASH_DNS -d 127.0.0.0/8 -j RETURN
iptables -t nat -A CLASH_DNS -m owner --uid-owner "$PROXY_BYPASS_USER" -j RETURN
iptables -t nat -A CLASH_DNS -m owner --uid-owner systemd-timesync -j RETURN
iptables -t nat -A CLASH_DNS -m cgroup --cgroup "$PROXY_BYPASS_CGROUP" -j RETURN
iptables -t nat -A CLASH_DNS -p udp -j REDIRECT --to-ports "$PROXY_DNS_PORT"

iptables -t mangle -I OUTPUT -j CLASH
iptables -t mangle -I PREROUTING -m set ! --match-set localnetwork dst -j MARK --set-mark "$PROXY_FWMARK"

iptables -t nat -I OUTPUT -p udp --dport 53 -j CLASH_DNS
iptables -t nat -I PREROUTING -p udp --dport 53 -j REDIRECT --to "$PROXY_DNS_PORT"

# echo $(date "+%Y-%m-%d %H:%M:%S") setup-tun.sh start >> /var/log/tun-up.log
# echo "---------------------------------------" >> /var/log/tun-up.log
