#openwrt set

rm -rf /etc/dnsmasq.d/dnsmasq-aliases-alt.conf
ipset flush vpn_ipsum
mkdir -p /etc/dnsmasq.d/
cp result/dnsmasq-ipset.conf /etc/dnsmasq.d/dnsmasq-aliases-alt.conf
# i have no idea why or how, but this command makes it all work
iptables -I PREROUTING -t mangle -m set --match-set vpn_ipsum dst -j MARK --set-mark 1
/etc/init.d/dnsmasq restart
/etc/init.d/firewall restart
iptables -I PREROUTING -t mangle -m set --match-set vpn_ipsum dst -j MARK --set-mark 1
echo "\"no lease, failing\" error is normal."