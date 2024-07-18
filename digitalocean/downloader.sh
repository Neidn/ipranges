#!/usr/bin/env bash

set -exuo pipefail
set -x

DIGITAL_OCEAN_URL="https://www.digitalocean.com/geo/google.csv"

TMP_DIR="$(mktemp -d)"
TMP_FILE="${TMP_DIR}/digitalocean.csv"
TMP_IPv4_FILE="${TMP_DIR}/digitalocean-ipv4.txt"
TMP_IPv6_FILE="${TMP_DIR}/digitalocean-ipv6.txt"

TARGET_DIR="digitalocean"
IPv4_TARGET_FILE="${TARGET_DIR}/digitalocean-ipv4.txt"
IPv6_TARGET_FILE="${TARGET_DIR}/digitalocean-ipv6.txt"

# Download the CSV file
curl -s "${DIGITAL_OCEAN_URL}" | cut -d, -f1 > "${TMP_FILE}"

# Extract the IPv4 and IPv6 addresses
grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+(\/[0-9]+)?$' "${TMP_FILE}" > "${TMP_IPv4_FILE}"
grep -E '^[0-9a-fA-F:]+(/[0-9]+)?$' "${TMP_FILE}" > "${TMP_IPv6_FILE}"

# Sort and remove duplicates
sort -V "${TMP_IPv4_FILE}" | uniq > "${IPv4_TARGET_FILE}"
sort -V "${TMP_IPv6_FILE}" | uniq > "${IPv6_TARGET_FILE}"

# Clean up
rm -rf "${TMP_DIR}"