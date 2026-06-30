#!/usr/bin/env bash

set -exuo pipefail
set -x

CHATGPT_CONNECTORS_URL="https://openai.com/chatgpt-connectors.json"
CHATGPT_AGENTS_URL="https://openai.com/chatgpt-agents.json"

TMP_DIR="$(mktemp -d)"
TMP_CONNECTORS_FILE="${TMP_DIR}/chatgpt-connectors.json"
TMP_AGENTS_FILE="${TMP_DIR}/chatgpt-agents.json"
TMP_IPv4_FILE="${TMP_DIR}/chatgpt-ipv4.txt"

TARGET_DIR="chatgpt"
IPv4_TARGET_FILE="${TARGET_DIR}/chatgpt-ipv4.txt"

# Download both JSON files
curl -s -o "${TMP_CONNECTORS_FILE}" "${CHATGPT_CONNECTORS_URL}"
curl -s -o "${TMP_AGENTS_FILE}" "${CHATGPT_AGENTS_URL}"

# Extract IPv4 prefixes from both sources
jq -r '.prefixes[] | .ipv4Prefix | select(. != null)' "${TMP_CONNECTORS_FILE}" > "${TMP_IPv4_FILE}"
jq -r '.prefixes[] | .ipv4Prefix | select(. != null)' "${TMP_AGENTS_FILE}" >> "${TMP_IPv4_FILE}"

# Sort and remove duplicates
sort -V "${TMP_IPv4_FILE}" | uniq > "${IPv4_TARGET_FILE}"

# Cleanup
rm -rf "${TMP_DIR}"
