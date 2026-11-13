#!/usr/bin/env bash
# ------------------------------------------------------------------
# 06_run_ecopcr.sh
# In silico PCR of every pair selected in step 05
# (results/insilico_selected_pairs.tsv), each against the database of its
# own design built in step 03:
#
#   ecoPCR -d <db> -k -e 3 -l 50 -L 300 <forward> <reverse>
#
#   -e 3       up to 3 mismatches per primer
#   -l / -L    amplicon of 50 to 300 bp
#   -k         needed with the NCBI taxonomy since 2025 (rank "superkingdom"
#              renamed "domain"); it only changes the classification
#              columns 11-12 of the output
#
# Output: results/ecopcr/raw/<target>_<length>_<serial>.ecopcr
# Already existing outputs are kept (the run can be resumed).
#
# Usage: bash scripts/06_run_ecopcr.sh [parallel jobs, default 2]
# ------------------------------------------------------------------
set -euo pipefail
cd "$(dirname "$0")/.."

ECOPCR="${ECOPCR:-ecoPCR}"
JOBS="${1:-2}"
PAIRS="results/insilico_selected_pairs.tsv"
OUT="results/ecopcr/raw"

command -v "$ECOPCR" >/dev/null || { echo "ERROR: ecoPCR not found in PATH" >&2; exit 1; }
[[ -s "$PAIRS" ]] || { echo "ERROR: $PAIRS not found (run step 05)" >&2; exit 1; }
mkdir -p "$OUT"

run_one() {
    local t=$1 n=$2 serial=$3 fwd=$4 rev=$5
    local out="$OUT/${t}_${n}_${serial}.ecopcr"
    [[ -s "$out" ]] && return 0
    local db="data/processed/${t}/${t}_db"
    [[ -s "${db}.tdx" ]] || { echo "ERROR: database not found: $db (run step 03)" >&2; return 1; }
    "$ECOPCR" -d "$db" -k -e 3 -l 50 -L 300 "$fwd" "$rev" > "${out}.tmp" 2>/dev/null
    mv "${out}.tmp" "$out"
}
export -f run_one
export ECOPCR OUT

tail -n +2 "$PAIRS" | cut -f1-5 | xargs -P "$JOBS" -L 1 bash -c 'run_one "$@"' _

echo "[06] $(ls "$OUT" | grep -c '\.ecopcr$') ecoPCR outputs in $OUT ($(( $(wc -l < "$PAIRS") - 1 )) pairs selected)"
