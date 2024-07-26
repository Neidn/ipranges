#!/usr/bin/env bash

set -exuo pipefail
set -x

VULTR_IP_URL="https://geofeed.constant.com/?text"

TMP_DIR="$(mktemp -d)"
TMP_FILE="${TMP_DIR}/vultr.txt"
TMP_IPv4_FILE="${TMP_DIR}/vultr-ipv4.txt"
TMP_IPv6_FILE="${TMP_DIR}/vultr-ipv6.txt"

TARGET_DIR="vultr"
TARGET_IPv4_FILE="${TARGET_DIR}/vultr-ipv4.txt"
TARGET_IPv6_FILE="${TARGET_DIR}/vultr-ipv6.txt"

# Download the IPv4 and IPv6 lists
curl -s -o "${TMP_FILE}" "${VULTR_IP_URL}"

# Extract the ipv4 and ipv6 addresses
grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+(\/[0-9]+)?$' "${TMP_FILE}" > "${TMP_IPv4_FILE}"
grep -E '^[0-9a-fA-F:]+(/[0-9]+)?$' "${TMP_FILE}" > "${TMP_IPv6_FILE}"

# Sort and remove duplicates
sort -V "${TMP_IPv4_FILE}" | uniq > "${TARGET_IPv4_FILE}"
sort -V "${TMP_IPv6_FILE}" | uniq > "${TARGET_IPv6_FILE}"

# Clean up
rm -rf "${TMP_DIR}"
