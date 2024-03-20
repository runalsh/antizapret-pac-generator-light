#!/bin/bash

set -e
LANG=C.UTF-8
HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

#install necessary tools
apt update
apt install curl coreutils gawk sipcalc python3 python3-pip -y
python3 -m pip install --upgrade pip --break-system-packages
pip3 install --upgrade dnspython --break-system-packages

./update.sh
./parse.sh
./process.sh

./generate-pac.sh