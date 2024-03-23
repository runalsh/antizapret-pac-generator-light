awk '! a[$0]++' ./config/include-hosts-custom.txt
# sort -o ./config/include-hosts-custom.txt ./config/include-hosts-custom.txt
sed -i '/^$/d' ./config/include-hosts-custom.txt
sed -i '/#/d' ./config/include-hosts-custom.txt

awk '! a[$0]++' ./config/exclude-hosts-custom.txt
sed -i '/#/d' ./config/exclude-hosts-custom.txt