#!/bin/bash

set -e

LANG=C.UTF-8
HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

# clean 
rm -rf ./result/proxy-host-*.pac

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
