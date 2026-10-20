#!/usr/bin/env bash
# ------------------------------------------------------------------
# Step 01 - Convert the GenBank flat file (.gb) to FASTA with obiconvert
# Usage: bash scripts/01_convert_genbank.sh <target_id>
#
# obiconvert (OBITools 1.2.13) reads the GenBank records and, using the
# NCBI taxdump, writes each sequence with "organism=" and "taxid=" in
# its header. Records that cannot be parsed are skipped.
# ------------------------------------------------------------------
set -euo pipefail
cd "$(dirname "$0")/.."

TARGET="${1:?provide a target_id, e.g. 12s_pimelodidae}"
OBICONVERT="${OBICONVERT:-obiconvert}"

# --- paths ---
INPUT="data/raw/${TARGET}.gb"
TAXDUMP="data/taxdump"
OUTPUT_DIR="data/processed/${TARGET}"
OUTPUT="${OUTPUT_DIR}/${TARGET}.fasta"

# --- checks ---
[[ -s "$INPUT" ]] || { echo "ERROR: GenBank file not found: $INPUT" >&2; exit 1; }
[[ -s "$TAXDUMP/nodes.dmp" && -s "$TAXDUMP/names.dmp" ]] || {
    echo "ERROR: NCBI taxdump not found in $TAXDUMP (see README)" >&2; exit 1; }
command -v "$OBICONVERT" >/dev/null || { echo "ERROR: obiconvert not found in PATH" >&2; exit 1; }
mkdir -p "$OUTPUT_DIR"

# --- command ---
echo "[01] ${TARGET}: converting $INPUT -> $OUTPUT"
"$OBICONVERT" --skip-on-error --genbank -t "$TAXDUMP" "$INPUT" --fasta-output > "$OUTPUT"

echo "[01] ${TARGET}: $(grep -c '^>' "$OUTPUT") sequences written"
