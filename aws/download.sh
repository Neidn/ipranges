#!/usr/bin/env bash

set -exuo pipefail
set -x

AWS_IP_URL="https://ip-ranges.amazonaws.com/ip-ranges.json"

TMP_DIR="$(mktemp -d)"
TMP_FILE="${TMP_DIR}/amazon.json"
TMP_IPv4_FILE="${TMP_DIR}/amazon-ipv4.txt"
TMP_IPv6_FILE="${TMP_DIR}/amazon-ipv6.txt"

TARGET_DIR="aws"
IPv4_TARGET_FILE="${TARGET_DIR}/amazon-ipv4.txt"
IPv6_TARGET_FILE="${TARGET_DIR}/amazon-ipv6.txt"

# Download the file
curl -s -o "${TMP_FILE}" "${AWS_IP_URL}"

# Extract the prefixes
jq -r '.prefixes[] | .ip_prefix | select(. != null)' "${TMP_FILE}" > "${TMP_IPv4_FILE}"
jq -r '.ipv6_prefixes[] | .ipv6_prefix | select(. != null)' "${TMP_FILE}" > "${TMP_IPv6_FILE}"

# sort and remove duplicates
sort -V "${TMP_IPv4_FILE}" | uniq > "${IPv4_TARGET_FILE}"
sort -V "${TMP_IPv6_FILE}" | uniq > "${IPv6_TARGET_FILE}"

# Cleanup
rm -rf "${TMP_DIR}"
