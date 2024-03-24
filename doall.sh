#!/bin/bash

set -e

LANG=C.UTF-8
HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

# clean 
rm -rf ./result/*
rm -rf ./temp/*

./requirements.sh
./parseitdog.sh # https://raw.githubusercontent.com/itdoginfo/allow-domains/main/Russia/inside-dnsmasq-ipset.lst
./antifilter-ce.sh # https://community.antifilter.download/list/domains.lst
./openai.sh # https://raw.githubusercontent.com/antonme/ipnames/master/dns-openai.txt
./svintuss.sh # https://raw.githubusercontent.com/svintuss/unblock/main/unblock.txt
./preparelst.sh
./update.sh
./parse.sh
./process.sh

./generate-pac.sh

echo "EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE"

source config/config.sh

if [[ "$EXCLUDE_PATTERN_PAC" == "yes" ]];
then
    rm -rf ./temp/{exclude-hosts.txt,include-ips.txt,hostlist_original_with_include.txt,include-hosts.txt,include-ips.txt,pacpatterns.js,replace-common-sequences.awk}
    ./excludepattern.sh
    ./parse.sh
    ./process.sh
    cp generate-pac.sh generate-pac-pattern.sh
    sed -i 's/PACFILE/PACFILE_PATTERN/' generate-pac-pattern.sh
    ./generate-pac-pattern.sh
    echo "RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR"
fi

rm -rf ./result/*.txt
rm -rf ./result/*.conf
rm -rf ./temp/*