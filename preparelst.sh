sed -i '/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/d' ./config/{include-hosts-custom.txt,exclude-hosts-custom.txt}
sed -i '/[0-9]\{1,4\}\:[0-9]\{1,4\}\:[0-9]\{1,4\}\:[0-9]\{1,4\}/d' ./config/{include-hosts-custom.txt,exclude-hosts-custom.txt}

# awk '! a[$0]++' ./config/{include-hosts-custom.txt,exclude-hosts-custom.txt}
# sort -o ./config/include-hosts-custom.txt ./config/include-hosts-custom.txt
sort config/include-hosts-custom.txt | uniq > config/include-hosts-custom.txt
sed -i '/^$/d' ./config/{include-hosts-custom.txt,exclude-hosts-custom.txt}
sed -i '/#/d' ./config/{include-hosts-custom.txt,exclude-hosts-custom.txt}