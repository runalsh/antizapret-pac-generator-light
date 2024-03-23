set -e

rm -rf openai-*.lst
wget -O openai-`date '+%d-%B-%Y'`.lst https://raw.githubusercontent.com/antonme/ipnames/master/dns-openai.txt
cat openai-`date '+%d-%B-%Y'`.lst >> ./config/include-hosts-custom.txt
rm -rf openai-*.lst
# awk '! a[$0]++' ./config/include-hosts-custom.txt
# # sort -o ./config/include-hosts-custom.txt ./config/include-hosts-custom.txt
# sed -i '/^$/d' ./config/include-hosts-custom.txt