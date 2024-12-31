#!/usr/bin/env bash

set -exuo pipefail
set -x

OVH_IP4_URL="https://rest.db.ripe.net/search?source=ripe&query-string=OVH&select-attributes=inetnum&flags=no-referenced&flags=no-irt&flags=no-filtering"
OVH_IP6_URL="https://rest.db.ripe.net/search?source=ripe&query-string=OVH&select-attributes=inet6num&flags=no-referenced&flags=no-irt&flags=no-filtering"

TMP_DIR="$(mktemp -d)"
TMP_FILE="${TMP_DIR}/ovh.txt"
TMP_IPv4_FILE="${TMP_DIR}/ovh-ipv4.txt"
TMP_IPv6_FILE="${TMP_DIR}/ovh-ipv6.txt"

TARGET_DIR="ovh"
IPv4_TARGET_FILE="${TARGET_DIR}/ovh-ipv4.txt"
IPv6_TARGET_FILE="${TARGET_DIR}/ovh-ipv6.txt"

# Download the xml file
curl -s "${OVH_URL}" | xmllint --xpath '//attribute[@name="inetnum"]/@value' - | awk -F'"' '{print $2}' > "${TMP_FILE}"

# Extract the IPv4 and IPv6 addresses
grep -E '\b((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\/(3[0-2]|[12]?[0-9])?\b' "${TMP_FILE}" > "${TMP_IPv4_FILE}"
grep -E '\b([0-9a-fA-F]{1,4}:){7}([0-9a-fA-F]{1,4}|:)(\/([0-9]|[1-9][0-9]|1[0-1][0-9]|12[0-8]))\b|\b([0-9a-fA-F]{1,4}:){1,7}:(\/([0-9]|[1-9][0-9]|1[0-1][0-9]|12[0-8]))\b|\b([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}(\/([0-9]|[1-9][0-9]|1[0-1][0-9]|12[0-8]))\b|\b([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}(\/([0-9]|[1-9][0-9]|1[0-1][0-9]|12[0-8]))\b|\b([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}(\/([0-9]|[1-9][0-9]|1[0-1][0-9]|12[0-8]))\b|\b([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}(\/([0-9]|[1-9][0-9]|1[0-1][0-9]|12[0-8]))\b|\b([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}(\/([0-9]|[1-9][0-9]|1[0-1][0-9]|12[0-8]))\b|\b[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})(\/([0-9]|[1-9][0-9]|1[0-1][0-9]|12[0-8]))\b|\b:((:[0-9a-fA-F]{1,4}){1,7}|:)(\/([0-9]|[1-9][0-9]|1[0-1][0-9]|12[0-8]))\b|\bfe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}(\/([0-9]|[1-9][0-9]|1[0-1][0-9]|12[0-8]))\b|\b::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9])?[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9])?[0-9])(\/([0-9]|[1-9][0-9]|1[0-1][0-9]|12[0-8]))\b|\b([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9])?[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9])?[0-9])(\/([0-9]|[1-9][0-9]|1[0-1][0-9]|12[0-8]))\b' "${TMP_FILE}" > "${TMP_IPv6_FILE}"

# Sort and remove duplicates
sort -V "${TMP_IPv4_FILE}" | uniq > "${IPv4_TARGET_FILE}"
sort -V "${TMP_IPv6_FILE}" | uniq > "${IPv6_TARGET_FILE}"

# Clean up
rm -rf "${TMP_DIR}"
