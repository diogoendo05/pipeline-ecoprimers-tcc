#!/usr/bin/env bash
# ------------------------------------------------------------------
# Step 04 - Run ecoPrimers for primer lengths of 20 to 25 bp
# Usage: bash scripts/04_run_ecoprimers.sh <target_id>
#
# Example group  (-r): the target species (root_taxid).
# Counterexamples (-i): every other taxid found in the reference set.
# For each primer length N, the whole primer must match strictly at the
# 3' end (-3 N), and a primer may match each record only once (-U).
# Mismatches (-e) and quorums (-q, -s) are left at ecoPrimers defaults.
# ------------------------------------------------------------------
set -euo pipefail
cd "$(dirname "$0")/.."

TARGET="${1:?provide a target_id, e.g. 12s_pimelodidae}"
ECOPRIMERS="${ECOPRIMERS:-ecoPrimers}"
TARGETS_FILE="config/targets.tsv"

# --- parameters read from config/targets.tsv ---
read -r ROOT_TAXID MIN_LEN MAX_LEN < <(
    awk -F '\t' -v t="$TARGET" '
        NR == 1 { for (i = 1; i <= NF; i++) col[$i] = i; next }
        $col["target_id"] == t { print $col["root_taxid"], $col["min_len"], $col["max_len"]; found = 1 }
        END { if (!found) exit 1 }' "$TARGETS_FILE"
) || { echo "ERROR: target '$TARGET' not found in $TARGETS_FILE" >&2; exit 1; }

# --- ecoPrimers parameters ---
PRIMER_LENGTHS=(20 21 22 23 24 25)

# --- paths ---
DATABASE="data/processed/${TARGET}/${TARGET}_db"
TAXIDS="data/processed/${TARGET}/${TARGET}_taxids.txt"
OUTPUT_DIR="results/${TARGET}"

# --- checks ---
[[ -n "$ROOT_TAXID" && -n "$MIN_LEN" && -n "$MAX_LEN" ]] || {
    echo "ERROR: root_taxid/min_len/max_len missing for $TARGET in $TARGETS_FILE" >&2; exit 1; }
[[ -s "${DATABASE}.tdx" ]] || { echo "ERROR: database not found: $DATABASE (run step 03)" >&2; exit 1; }
[[ -s "$TAXIDS" ]] || { echo "ERROR: taxid list not found: $TAXIDS (run step 02)" >&2; exit 1; }
command -v "$ECOPRIMERS" >/dev/null || { echo "ERROR: ecoPrimers not found in PATH" >&2; exit 1; }
grep -qx "$ROOT_TAXID" "$TAXIDS" || echo "WARNING: root taxid $ROOT_TAXID is not in $TAXIDS" >&2
mkdir -p "$OUTPUT_DIR"

# Counterexamples: all taxids except the target species
COUNTEREXAMPLES=()
while read -r taxid; do
    [[ -n "$taxid" && "$taxid" != "$ROOT_TAXID" ]] && COUNTEREXAMPLES+=(-i "$taxid")
done < "$TAXIDS"

echo "[04] ${TARGET}: root taxid $ROOT_TAXID, $(( ${#COUNTEREXAMPLES[@]} / 2 )) counterexample taxids, amplicon ${MIN_LEN}-${MAX_LEN} bp"

# --- run loop ---
for N in "${PRIMER_LENGTHS[@]}"; do
    OUTPUT="${OUTPUT_DIR}/${TARGET}_ecoprimers${N}.csv"
    echo "[04] ${TARGET}: primer length ${N} bp -> $OUTPUT"
    "$ECOPRIMERS" -d "$DATABASE" -l "$MIN_LEN" -L "$MAX_LEN" -r "$ROOT_TAXID" \
        "${COUNTEREXAMPLES[@]}" -3 "$N" -U -O "$N" > "$OUTPUT"
    echo "[04] ${TARGET}: $(grep -vc '^#' "$OUTPUT" || true) primer pairs"
done
