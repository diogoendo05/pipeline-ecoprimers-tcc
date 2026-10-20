#!/usr/bin/env bash
# ------------------------------------------------------------------
# Main runner - executes steps 01 to 04 for each target
# Usage:
#   bash scripts/run_all_targets.sh                       # all targets
#   bash scripts/run_all_targets.sh 12s_tibagi 16s_tibagi # selected targets
# ------------------------------------------------------------------
set -euo pipefail
cd "$(dirname "$0")/.."

TARGETS="config/targets.tsv"

# --- target list ---
if (( $# > 0 )); then
    TARGET_LIST=("$@")
else
    mapfile -t TARGET_LIST < <(awk -F '\t' 'NR > 1 && $1 != "" { print $1 }' "$TARGETS")
fi

for target in "${TARGET_LIST[@]}"; do
    awk -F '\t' -v t="$target" 'NR > 1 && $1 == t { found = 1 } END { exit !found }' "$TARGETS" || {
        echo "ERROR: target '$target' not found in $TARGETS" >&2; exit 1; }
done

# --- main loop: steps 01 to 04 per target ---
FAILED=()
for target in "${TARGET_LIST[@]}"; do
    echo "=================== ${target} ==================="
    if bash scripts/01_convert_genbank.sh "$target" &&
       bash scripts/02_extract_taxids.sh "$target" &&
       bash scripts/03_format_ecopcr_db.sh "$target" &&
       bash scripts/04_run_ecoprimers.sh "$target"; then
        :
    else
        echo "!! ${target}: failed, continuing with the next target" >&2
        FAILED+=("$target")
    fi
done

# --- final summary: primer pairs per primer length ---
echo
echo "=================== summary ==================="
printf '%-18s' "target"
for N in 20 21 22 23 24 25; do printf '%8s' "${N}bp"; done
echo
for target in "${TARGET_LIST[@]}"; do
    printf '%-18s' "$target"
    for N in 20 21 22 23 24 25; do
        f="results/${target}/${target}_ecoprimers${N}.csv"
        if [[ -f "$f" ]]; then printf '%8s' "$(grep -vc '^#' "$f" || true)"; else printf '%8s' "-"; fi
    done
    echo
done

if (( ${#FAILED[@]} > 0 )); then
    echo "Failed targets: ${FAILED[*]}" >&2
    exit 1
fi
