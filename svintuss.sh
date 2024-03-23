set -e

rm -rf svintuss-*.lst
wget -O svintuss-`date '+%d-%B-%Y'`.lst https://raw.githubusercontent.com/svintuss/unblock/main/unblock.txt
sed -i '/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/d' svintuss-`date '+%d-%B-%Y'`.lst
cat svintuss-`date '+%d-%B-%Y'`.lst >> ./config/include-hosts-custom.txt
rm -rf svintuss-*.lst
# awk '! a[$0]++' ./config/include-hosts-custom.txt
# # sort -o ./config/include-hosts-custom.txt ./config/include-hosts-custom.txt
# sed -i '/^$/d' ./config/include-hosts-custom.txt