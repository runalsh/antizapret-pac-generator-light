#!/bin/bash

set -e

LANG=C.UTF-8
HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

./requirements.sh
./parseitdog.sh # https://raw.githubusercontent.com/itdoginfo/allow-domains/main/Russia/inside-dnsmasq-ipset.lst
./update.sh
./parse.sh
./process.sh

./generate-pac.sh

# clean 
rm -rf itdog-*.lst