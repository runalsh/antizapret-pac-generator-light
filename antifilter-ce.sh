set -e

rm -rf antifilter-*.lst
wget -O antifilter-`date '+%d-%B-%Y'`.lst https://community.antifilter.download/list/domains.lst
cat antifilter-`date '+%d-%B-%Y'`.lst >> ./config/include-hosts-custom.txt
wget -O antifilter-ip-`date '+%d-%B-%Y'`.lst https://antifilter.download/list/ip.lst
cat antifilter-ip-`date '+%d-%B-%Y'`.lst >> ./config/include-ips-custom.txt
wget -O antifilter-ip-resolve-`date '+%d-%B-%Y'`.lst https://antifilter.download/list/ipresolve.lst
cat antifilter-ip-resolve-`date '+%d-%B-%Y'`.lst >> ./config/include-ips-custom.txt
rm -rf antifilter-*.lst
# awk '! a[$0]++' ./config/include-hosts-custom.txt
# # sort -o ./config/include-hosts-custom.txt ./config/include-hosts-custom.txt
# sed -i '/^$/d' ./config/include-hosts-custom.txt