set -e

rm -rf other-*.lst

# spotify
wget -O other-spotify-`date '+%d-%B-%Y'`.lst https://raw.githubusercontent.com/naruto522ru/ipranges/main/spotify/ipv4.txt
cat other-spotify-`date '+%d-%B-%Y'`.lst >> ./config/include-ips-custom.txt
#facebook
#https://raw.githubusercontent.com/antonme/ipnames/master/ext-dns-facebook.txt
#https://raw.githubusercontent.com/antonme/ipnames/master/dns-facebook.txt




rm -rf other-*.lst