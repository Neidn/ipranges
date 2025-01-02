#!/usr/bin/env bash

set -exuo pipefail
set -x

ASN="AS16276"
OVH_URL="https://rest.db.ripe.net/search?inverse-attribute=origin&source=ripe&query-string=${ASN}"

PWD=`pwd`
TMP_DIR="$(mktemp -d)"
TMP_FILE="ovh.txt"
TMP_IPv4_FILE="${TMP_DIR}/ovh-ipv4.txt"
TMP_IPv6_FILE="${TMP_DIR}/ovh-ipv6.txt"

TARGET_DIR="${PWD}/ovh"
IPv4_TARGET_FILE="${TARGET_DIR}/ovh-ipv4.txt"
IPv6_TARGET_FILE="${TARGET_DIR}/ovh-ipv6.txt"

# Download the xml file
cd "${TMP_DIR}"
curl -H 'Accept: application/json' -s "${OVH_URL}" > "${TMP_FILE}"

# Extract the IPv4 and IPv6 addresses
duckdb -c "COPY(WITH parsed_data AS (select unnest(json.objects.object) as object from read_json('${TMP_FILE}') json) SELECT object->'$.primary-key'->'$.attribute[0]'->'$.value' as list FROM parsed_data where object.type = 'route') TO '${TMP_IPv4_FILE}' (FORMAT 'csv', HEADER false, QUOTE '')"
duckdb -c "COPY(WITH parsed_data AS (select unnest(json.objects.object) as object from read_json('${TMP_FILE}') json) SELECT object->'$.primary-key'->'$.attribute[0]'->'$.value' as list FROM parsed_data where object.type = 'route6') TO '${TMP_IPv6_FILE}' (FORMAT 'csv', HEADER false, QUOTE '')"

# Remove Quotes
cd "${PWD}"
sed -i 's/"//g' "${TMP_IPv4_FILE}"
sed -i 's/"//g' "${TMP_IPv6_FILE}"

# Sort and remove duplicates
sort -V "${TMP_IPv4_FILE}" | uniq > "${IPv4_TARGET_FILE}"
sort -V "${TMP_IPv6_FILE}" | uniq > "${IPv6_TARGET_FILE}"

# Clean up
rm -rf "${TMP_DIR}"
