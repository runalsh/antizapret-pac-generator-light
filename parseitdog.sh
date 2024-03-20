set -e

rm -rf itdog-*.lst
# wget -O itdog-`date '+%d-%B-%Y'`.lst https://raw.githubusercontent.com/itdoginfo/allow-domains/main/Russia/inside-dnsmasq-ipset.lst
# sed -i 's/.vpn_domains//' itdog-`date '+%d-%B-%Y'`.lst
# sed -i 's/ipset=.//' itdog-`date '+%d-%B-%Y'`.lst
wget -O itdog-1-`date '+%d-%B-%Y'`.lst https://raw.githubusercontent.com/itdoginfo/allow-domains/main/Russia/inside-raw.lst
wget -O itdog-2-`date '+%d-%B-%Y'`.lst https://raw.githubusercontent.com/itdoginfo/allow-domains/main/src/Russia-domains-inside-single.lst
wget -O itdog-3-`date '+%d-%B-%Y'`.lst https://raw.githubusercontent.com/itdoginfo/allow-domains/main/src/Russia-domains-inside.lst
cat itdog-1-`date '+%d-%B-%Y'`.lst >> ./config/include-hosts-custom.txt
cat itdog-2-`date '+%d-%B-%Y'`.lst >> ./config/include-hosts-custom.txt
cat itdog-3-`date '+%d-%B-%Y'`.lst >> ./config/include-hosts-custom.txt
awk '! a[$0]++' ./config/include-hosts-custom.txt
# sort -o ./config/include-hosts-custom.txt ./config/include-hosts-custom.txt
sed -i '/^$/d' ./config/include-hosts-custom.txt

