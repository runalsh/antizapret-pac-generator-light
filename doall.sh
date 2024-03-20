#!/bin/bash

set -e
LANG=C.UTF-8
HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

./update.sh
./parse.sh
./process.sh
