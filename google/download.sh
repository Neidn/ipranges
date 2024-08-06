#!/usr/bin/env bash

set -exuo pipefail
set -x

GOOGLE_CLOUD_URL="https://www.gstatic.com/ipranges/cloud.json"

TMP_DIR="$(mktemp -d)"
TMP_FILE="${TMP_DIR}/google.json"
TMP_IPv4_FILE="${TMP_DIR}/google-ipv4.txt"
TMP_IPv6_FILE="${TMP_DIR}/google-ipv6.txt"

TARGET_DIR="google"
IPv4_TARGET_FILE="${TARGET_DIR}/google-ipv4.txt"
IPv6_TARGET_FILE="${TARGET_DIR}/google-ipv6.txt"

# Download the JSON file
curl -s -o "${TMP_FILE}" "${GOOGLE_CLOUD_URL}"

# Extract the prefixes
jq -r '.prefixes[] | .ipv4Prefix | select(. != null)' "${TMP_FILE}" > "${TMP_IPv4_FILE}"
jq -r '.prefixes[] | .ipv6Prefix | select(. != null)' "${TMP_FILE}" > "${TMP_IPv6_FILE}"

# sort and remove duplicates
sort -V "${TMP_IPv4_FILE}" | uniq > "${IPv4_TARGET_FILE}"
sort -V "${TMP_IPv6_FILE}" | uniq > "${IPv6_TARGET_FILE}"

# Cleanup
rm -rf "${TMP_DIR}"
