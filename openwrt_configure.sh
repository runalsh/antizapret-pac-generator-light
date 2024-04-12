#openwrt set

# /etc/config/firewall
# config ipset
#         option name 'vpn_ipsum'
#         option match 'dst_ip'
#         option maxelem '65535'

# use  option confdir '/etc/dnsmasq.d'    in /etc/config/dhcp under config dnsmasq

# echo '99 vpn_ipsum' >> /etc/iproute2/rt_tables

# 30-vpnroute в  /etc/hotplug.d/iface/
# #!/bin/sh
# ip route add table vpn_ipsum default dev awg1


rm -rf /etc/dnsmasq.d/dnsmasq-ipset.conf
ipset flush vpn_ipsum
mkdir -p /etc/dnsmasq.d/
cp result/dnsmasq-ipset.conf /etc/dnsmasq.d/dnsmasq-ipset.conf
iptables -I PREROUTING -t mangle -m set --match-set vpn_ipsum dst -j MARK --set-mark 1
/etc/init.d/dnsmasq restart
/etc/init.d/firewall restart
iptables -I PREROUTING -t mangle -m set --match-set vpn_ipsum dst -j MARK --set-mark 1
echo "\"no lease, failing\" error is normal."