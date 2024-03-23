set -e

rm -rf svintuss-*.lst
wget -O svintuss-`date '+%d-%B-%Y'`.lst https://raw.githubusercontent.com/svintuss/unblock/main/unblock.txt
cat svintuss-`date '+%d-%B-%Y'`.lst >> ./config/include-hosts-custom.txt
rm -rf svintuss-*.lst
# awk '! a[$0]++' ./config/include-hosts-custom.txt
# # sort -o ./config/include-hosts-custom.txt ./config/include-hosts-custom.txt
# sed -i '/^$/d' ./config/include-hosts-custom.txt