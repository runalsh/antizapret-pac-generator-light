sed -i '/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/d' ./config/{include-hosts-custom.txt,exclude-hosts-custom.txt}
sed -i '/[0-9]\{1,4\}\:[0-9]\{1,4\}\:[0-9]\{1,4\}\:[0-9]\{1,4\}/d' ./config/{include-hosts-custom.txt,exclude-hosts-custom.txt}

awk '! a[$0]++' ./config/{include-hosts-custom.txt,exclude-hosts-custom.txt,include-ips-custom.txt,exclude-ips-custom.txt}
# sort -o ./config/include-hosts-custom.txt ./config/include-hosts-custom.txt
sed -i '/^$/d' ./config/{include-hosts-custom.txt,exclude-hosts-custom.txt}
sed -i '/#/d' ./config/{include-hosts-custom.txt,exclude-hosts-custom.txt}