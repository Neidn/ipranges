#!/usr/bin/env bash

set -exuo pipefail

OVH_URL="https://rest.db.ripe.net/search?source=ripe&query-string=OVH&select-attributes=inetnum&flags=no-referenced&flags=no-irt&flags=no-filtering"

TMP_DIR="$(mktemp -d)"
TMP_FILE="${TMP_DIR}/ovh.txt"

TARGET_DIR="ovh"
TARGET_FILE="${TARGET_DIR}/ovh-ipv4.txt"

# Download the xml file
curl -s "${OVH_URL}" | xmllint --xpath '//attribute[@name="inetnum"]/@value' - | awk -F'"' '{print $2}' > "${TMP_FILE}"

# Extract and calculate the ipv4 subnets
cat "${TMP_FILE}" | while read line; do
  command="ipcalc ${line}"
  result=`$command | grep -v deaggregate`
  echo "$result" >> "${TARGET_FILE}"
done

# Sort the files
sort -V "${TARGET_FILE}" -o "${TARGET_FILE}"

# Clean up
rm -rf "${TMP_DIR}"
