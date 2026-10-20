#!/usr/bin/env bash
# ------------------------------------------------------------------
# Step 03 - Build the local ecoPCR database with ecoPCRFormat.py
# Usage: bash scripts/03_format_ecopcr_db.sh <target_id>
#
# Produces the binary database (<prefix>.adx, .ndx, .rdx, .tdx and
# <prefix>_001.sdx) that ecoPrimers reads in step 04.
# ------------------------------------------------------------------
set -euo pipefail
cd "$(dirname "$0")/.."

TARGET="${1:?provide a target_id, e.g. 12s_pimelodidae}"
PYTHON="${PYTHON:-python}"
ECOPCRFORMAT="${ECOPCRFORMAT:-$(command -v ecoPCRFormat.py || true)}"

# --- paths ---
FASTA="data/processed/${TARGET}/${TARGET}.fasta"
TAXDUMP="data/taxdump"
PREFIX="data/processed/${TARGET}/${TARGET}_db"

# --- checks ---
[[ -s "$FASTA" ]] || { echo "ERROR: FASTA file not found: $FASTA (run step 01)" >&2; exit 1; }
[[ -s "$TAXDUMP/nodes.dmp" ]] || { echo "ERROR: NCBI taxdump not found in $TAXDUMP" >&2; exit 1; }
[[ -n "$ECOPCRFORMAT" && -f "$ECOPCRFORMAT" ]] || {
    echo "ERROR: ecoPCRFormat.py not found; set ECOPCRFORMAT=/path/to/ecoPCRFormat.py" >&2; exit 1; }

# --- command ---
echo "[03] ${TARGET}: building ecoPCR database $PREFIX"
"$PYTHON" "$ECOPCRFORMAT" --fasta --taxonomy "$TAXDUMP" --name "$PREFIX" "$FASTA"

echo "[03] ${TARGET}: database ready"
