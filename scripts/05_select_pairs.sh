#!/usr/bin/env bash
# ------------------------------------------------------------------
# 05_select_pairs.sh
# Applies the post-ecoPrimers filters used in the analysis and decides
# which runs go on to the in silico PCR (ecoPCR):
#
#   dif 3 = 0   minimum Tm of the forward primer (column 5) equal to the
#               minimum Tm of the reverse primer (column 7)
#   GG          quality class of the pair (column 10)
#
# A run (target x primer length) with no pair passing both filters is
# NOT tested with ecoPCR; it is recorded as "not tested".
#
# Output:
#   results/insilico_selection.tsv       one line per run
#   results/insilico_selected_pairs.tsv  the pairs that passed
#
# Usage: bash scripts/05_select_pairs.sh
# ------------------------------------------------------------------
set -euo pipefail
cd "$(dirname "$0")/.."

SUMMARY="results/insilico_selection.tsv"
PAIRS="results/insilico_selected_pairs.tsv"

printf 'target_id\tprimer_length\ttotal_pairs\tdif3_0\tdif3_0_and_GG\tin_silico_pcr\n' > "$SUMMARY"
printf 'target_id\tprimer_length\tserial\tforward\treverse\tmin_Tm_forward\tmin_Tm_reverse\tclass\tamplicon_min\tamplicon_max\n' > "$PAIRS"

tail -n +2 config/targets.tsv | cut -f1 | while read -r target; do
    for N in 20 21 22 23 24 25; do
        csv="results/${target}/${target}_ecoprimers${N}.csv"
        if [[ ! -f "$csv" ]]; then
            echo "missing: $csv" >&2
            continue
        fi
        awk -F'\t' -v t="$target" -v n="$N" -v pairs="$PAIRS" '
            /^#/ || NF < 20 { next }
            {
                total++
                gsub(/ /, "", $1)
                if ($5 + 0 == $7 + 0) {
                    d++
                    if ($10 == "GG") {
                        g++
                        printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", t, n, $1, $2, $3, $5, $7, $10, $19, $20 >> pairs
                    }
                }
            }
            END {
                status = (g > 0) ? "yes" : "not tested: no pair passed dif3=0 and GG"
                printf "%s\t%s\t%d\t%d\t%d\t%s\n", t, n, total, d, g, status
            }' "$csv" >> "$SUMMARY"
    done
done

cat "$SUMMARY"
echo
echo "Selected pairs: $(( $(wc -l < "$PAIRS") - 1 ))  ->  $PAIRS"
