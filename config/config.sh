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
RESOLVE_NXDOMAIN="yes"
