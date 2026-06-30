#!/usr/bin/env bash

set -exuo pipefail
set -x

CLAUDE_DOCS_URL="https://platform.claude.com/docs/en/api/ip-addresses"

TMP_DIR="$(mktemp -d)"
TMP_FILE="${TMP_DIR}/claude.html"
TMP_IPv4_FILE="${TMP_DIR}/claude-ipv4.txt"
TMP_IPv6_FILE="${TMP_DIR}/claude-ipv6.txt"

TARGET_DIR="claude"
IPv4_TARGET_FILE="${TARGET_DIR}/claude-ipv4.txt"
IPv6_TARGET_FILE="${TARGET_DIR}/claude-ipv6.txt"

# Download the docs page
curl -s -L "${CLAUDE_DOCS_URL}" -o "${TMP_FILE}"

# Extract IPv4 CIDRs (require prefix length to avoid false positives)
grep -oE '\b((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\/(3[0-2]|[12]?[0-9])\b' "${TMP_FILE}" > "${TMP_IPv4_FILE}"

# Extract IPv6 CIDRs (require prefix length to avoid false positives)
grep -oE '[0-9a-fA-F:]+\/[0-9]{1,3}' "${TMP_FILE}" | grep -E '^([0-9a-fA-F]{1,4}:){2}' > "${TMP_IPv6_FILE}"

# Verify extraction succeeded
[ -s "${TMP_IPv4_FILE}" ] || { echo "No IPv4 ranges found — page format may have changed"; exit 1; }

# Sort and remove duplicates
sort -V "${TMP_IPv4_FILE}" | uniq > "${IPv4_TARGET_FILE}"
sort -V "${TMP_IPv6_FILE}" | uniq > "${IPv6_TARGET_FILE}"

# Cleanup
rm -rf "${TMP_DIR}"
