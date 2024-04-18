#!/bin/bash

# HTTPS (TLS) proxy address
PACHTTPSHOST='127.0.0.1:6666'

# Regular proxy address
PACPROXYHOST='127.0.0.1:6666'

# Facebook and Twitter proxy address
PACFBTWHOST='127.0.0.1:6666'

PACFILE="result/proxy-host-ssl.pac"
PACFILE_NOSSL="result/proxy-host-nossl.pac"

# Perform DNS resolving to detect and filter non-existent domains
RESOLVE_NXDOMAIN="no"

PACONIONPROXYHOST='127.0.0.1:9050' #socks proxy for tor

PACI2PROXYHOST='127.0.0.1:4444' #http proxy for i2p

EXCLUDE_PATTERN_PAC="yes"
PACFILE_PATTERN="result/proxy-host-ssl-pattern.pac"
PACFILE_PATTERN_NOSSL="result/proxy-host-nossl-pattern.pac"

DNSMASQ_IPSET_GENERATE="yes"
DNSMASQ_IPSET_IP="127.0.0.1"
DNSMASQ_IPSET_TABLE="vpn_ipsum"

DNSMASQ_ALIASES_ALT_IP="127.0.0.4" #default 127.0.0.4
