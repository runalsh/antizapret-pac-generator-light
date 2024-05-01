#!/bin/bash

readarray -t domains < ./config/include-host-to-resolve.txt

for domain in "${domains[@]}"; do
    ip_addresses=$(dig +short "$domain" | grep -E '([0-9]{1,3}\.){3}[0-9]{1,3}')
    echo "$ip_addresses" >> ./config/include-ips-custom.txt
done