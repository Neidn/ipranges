# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Does

Collects public IP ranges from cloud providers daily via GitHub Actions. Each provider has a `download.sh` that fetches upstream data, extracts CIDRs, sorts, deduplicates, and writes to `{provider}/{provider}-ipv4.txt` and `{provider}/{provider}-ipv6.txt`.

## Running Scripts Locally

Run a provider's download script from the **repo root**:

```bash
bash amazon/download.sh
bash google/download.sh
bash ovh/download.sh     # requires duckdb
# etc.
```

Scripts use `set -exuo pipefail` — they fail fast on any error.

## Adding a New Provider

1. Create `{provider}/download.sh` following the existing pattern:
   - Download upstream data to `mktemp -d`
   - Extract CIDRs using `jq`, `grep`, or `duckdb`
   - `sort -V ... | uniq` into `{provider}/{provider}-ipv{4,6}.txt`
   - Clean up `TMP_DIR`
2. Create `.github/workflows/update_{provider}.yml` — copy an existing workflow, update `name`, the `run` step, and `file_pattern`

## Data Source Patterns

| Provider | Source format | Parse tool |
|----------|--------------|------------|
| Amazon, Google, Oracle | JSON | `jq` |
| OVH | JSON (RIPE REST API) | `duckdb` |
| Cloudflare | Plain text | `sort` only |
| Vultr, DigitalOcean, Scaleway | CSV / text | `grep -E` regex |

## Dependencies

- `curl`, `jq`, `sort`, `grep`, `sed` — standard
- `duckdb` — only required for OVH (`ovh/download.sh`)

## CI Behavior

Workflows run daily (`cron: '0 0 * * *'`). On change, `stefanzweifel/git-auto-commit-action` commits `*/*.txt` with `--no-verify --force`. Microsoft is planned but not yet implemented (stub `microsoft/download.sh` is empty).
