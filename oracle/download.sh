#!/usr/bin/env bash

set -exuo pipefail
set -x

ORACLE_URL="https://docs.oracle.com/en-us/iaas/tools/public_ip_ranges.json"

TMP_DIR="$(mktemp -d)"
TMP_FILE="${TMP_DIR}/oracle.json"
TMP_IPv4_FILE="${TMP_DIR}/oracle-ipv4.txt"

TARGET_DIR="oracle"
IPv4_TARGET_FILE="${TARGET_DIR}/oracle-ipv4.txt"

# Download the file
curl -s -o "${TMP_FILE}" "${ORACLE_URL}"

# Extract the prefixes
jq '.regions[] | .cidrs[] | .cidr | select(. != null)' "${TMP_FILE}" | sed 's/"//g' > "${TMP_IPv4_FILE}"

# sort and remove duplicates
sort -V "${TMP_IPv4_FILE}" | uniq > "${IPv4_TARGET_FILE}"

# Cleanup
rm -rf "${TMP_DIR}"
