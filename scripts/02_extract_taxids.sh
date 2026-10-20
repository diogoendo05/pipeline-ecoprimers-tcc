#!/usr/bin/env bash
# ------------------------------------------------------------------
# Step 02 - Extract the unique taxids present in the FASTA file
# Usage: bash scripts/02_extract_taxids.sh <target_id>
#
# The resulting list is used in step 04: every taxid except the target
# species (root_taxid in config/targets.tsv) is passed to ecoPrimers
# with -i, so that the other species act as counterexamples.
# Taxids listed in the optional "excluded_taxids" column of
# config/targets.tsv (comma-separated) are removed from the list.
# ------------------------------------------------------------------
set -euo pipefail
cd "$(dirname "$0")/.."

TARGET="${1:?provide a target_id, e.g. 12s_pimelodidae}"
TARGETS_FILE="config/targets.tsv"

# --- paths ---
INPUT="data/processed/${TARGET}/${TARGET}.fasta"
OUTPUT="data/processed/${TARGET}/${TARGET}_taxids.txt"

# --- checks ---
[[ -s "$INPUT" ]] || { echo "ERROR: FASTA file not found: $INPUT (run step 01)" >&2; exit 1; }

# --- taxids removed by hand for this target (may be empty) ---
EXCLUDED="$(awk -F '\t' -v t="$TARGET" '
    NR == 1 { for (i = 1; i <= NF; i++) col[$i] = i; next }
    $1 == t && ("excluded_taxids" in col) { print $col["excluded_taxids"] }' "$TARGETS_FILE")"

# --- command ---
echo "[02] ${TARGET}: extracting taxids from $INPUT"
grep -i -o 'taxid=[0-9]*' "$INPUT" | cut -d '=' -f 2 | sort | uniq > "$OUTPUT"

if [[ -n "$EXCLUDED" ]]; then
    echo "[02] ${TARGET}: removing excluded taxids: $EXCLUDED"
    tr ',' '\n' <<< "$EXCLUDED" | grep -vxFf - "$OUTPUT" > "${OUTPUT}.tmp" || true
    mv "${OUTPUT}.tmp" "$OUTPUT"
fi

echo "[02] ${TARGET}: $(wc -l < "$OUTPUT") unique taxids written to $OUTPUT"
