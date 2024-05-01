#!/bin/bash

domains=(
    "apt.releases.hashicorp.com"
    "releases.hashicorp.com"
    "hashicorp.com"
    "dl.tailscale.com"
    "vagrantcloud.com"
    "vagrantup.com"
    "registry.terraform.io"
    "terraform.io"
    "tailscale.com"
    "pkgs.tailscale.com"
)

for domain in "${domains[@]}"; do
    echo "Resolving $domain:"
    ip_addresses=$(dig +short "$domain")
    if [ -z "$ip_addresses" ]; then
        echo "Unable to resolve $domain"
    else
        echo "$ip_addresses" | while read -r ip_address; do
            echo "$domain: $ip_address"
        done
    fi
    echo
done
