#!/bin/bash

for octet in {1..49}; do
    ipaddr="192.168.1.$octet"
    hname="$(nslookup $ipaddr | awk -F= '/name/ {print $2}' | sed 's/.$//')"
    printf "%5s\t%s\n" "$ipaddr" "$hname"
done
