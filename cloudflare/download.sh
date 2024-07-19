#!/usr/bin/env bash

set -exuo pipefail
set -x

CLOUDFLARE_IP4_URL="https://www.cloudflare.com/ips-v4"
CLOUDFLARE_IP6_URL="https://www.cloudflare.com/ips-v6"

TMP_DIR="$(mktemp -d)"
TMP_IPv4_FILE="${TMP_DIR}/cloudflare-ipv4.txt"
TMP_IPv6_FILE="${TMP_DIR}/cloudflare-ipv6.txt"

TARGET_DIR="cloudflare"
IPv4_TARGET_FILE="${TARGET_DIR}/cloudflare-ipv4.txt"
IPv6_TARGET_FILE="${TARGET_DIR}/cloudflare-ipv6.txt"

# Download the IPv4 and IPv6 lists
curl -s -o "${TMP_IPv4_FILE}" "${CLOUDFLARE_IP4_URL}"
curl -s -o "${TMP_IPv6_FILE}" "${CLOUDFLARE_IP6_URL}"

# sort and remove duplicates
sort -u "${TMP_IPv4_FILE}" > "${IPv4_TARGET_FILE}"
sort -u "${TMP_IPv6_FILE}" > "${IPv6_TARGET_FILE}"

# cleanup
rm -rf "${TMP_DIR}"