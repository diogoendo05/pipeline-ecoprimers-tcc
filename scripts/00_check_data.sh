#!/usr/bin/env bash
# ------------------------------------------------------------------
# Step 00 - Check the input data before running the pipeline
# Usage:
#   bash scripts/00_check_data.sh                       # all targets
#   bash scripts/00_check_data.sh 12s_tibagi 16s_tibagi # selected targets
#
# For each target it checks:
#   - the GenBank query uses the right marker term (12S / 16S)
#   - the .gb record count matches the count logged in the query file
#   - the .gb records describe the expected marker (definition line or
#     rRNA /product), and how many are predicted/nuclear mRNA records
#   - the FASTA records all come from the .gb file
#   - the target species (root_taxid) is present in the FASTA file
#   - the taxid list is up to date with the FASTA file
#   - the 12S and 16S sets of the same reference set are not the same data
#
# Levels: OK, WARN (check by hand), FAIL (the pipeline cannot run or the
# results would be meaningless). Exit code is 1 if any FAIL is found.
# Only reads files; nothing is changed.
# ------------------------------------------------------------------
set -euo pipefail
cd "$(dirname "$0")/.."

TARGETS="config/targets.tsv"
MIN_MARKER_SHARE=80   # % of .gb records that must mention the expected marker
MAX_OVERLAP_SHARE=50  # % of accessions a 12S set may share with its 16S pair

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

N_FAIL=0
N_WARN=0
ok()   { printf '  OK    %s\n' "$*"; }
warn() { printf '  WARN  %s\n' "$*"; N_WARN=$((N_WARN + 1)); }
fail() { printf '  FAIL  %s\n' "$*"; N_FAIL=$((N_FAIL + 1)); }

# column value from targets.tsv: col <target> <column>
col() {
    awk -F '\t' -v t="$1" -v c="$2" '
        NR == 1 { for (i = 1; i <= NF; i++) h[$i] = i; next }
        $1 == t && (c in h) { print $h[c] }' "$TARGETS"
}

# One line per GenBank record: accession <TAB> class <TAB> mrna <TAB> definition
#   class: own   = mentions the expected marker
#          other = mentions only the other marker
#          none  = mentions neither
genbank_summary() {
    local gb="$1" marker="$2"
    awk -v marker="$marker" '
        BEGIN {
            IGNORECASE = 1
            own   = (marker == "12S") ? "12S|s-rRNA|small subunit ribosomal" : "16S|l-rRNA|large subunit ribosomal"
            other = (marker == "12S") ? "16S|l-rRNA|large subunit ribosomal" : "12S|s-rRNA|small subunit ribosomal"
        }
        function flush() {
            if (acc == "") return
            text = def " " prod
            cls = (toupper(text) ~ toupper(own)) ? "own" : (toupper(text) ~ toupper(other)) ? "other" : "none"
            gsub(/\t/, " ", def)
            print acc "\t" cls "\t" mrna "\t" def
            acc = def = prod = ""; mrna = 0; indef = 0
        }
        /^LOCUS/      { flush(); mrna = ($0 ~ /mRNA/) ? 1 : 0; next }
        /^ACCESSION/  { acc = $2; indef = 0; next }
        /^DEFINITION/ { def = substr($0, 13); indef = 1; next }
        /^[A-Z]/      { indef = 0 }
        indef && /^            / { def = def " " substr($0, 13); next }
        /\/product=/  { prod = prod " " $0 }
        /^\/\//       { flush() }
        END           { flush() }' "$gb"
}

# --- target list ---
if (( $# > 0 )); then
    TARGET_LIST=("$@")
else
    mapfile -t TARGET_LIST < <(awk -F '\t' 'NR > 1 && $1 != "" { print $1 }' "$TARGETS")
fi

for target in "${TARGET_LIST[@]}"; do
    echo "=== ${target}"
    marker="$(col "$target" marker)"
    root="$(col "$target" root_taxid)"
    excluded="$(col "$target" excluded_taxids)"
    if [[ -z "$marker" ]]; then fail "target not found in $TARGETS"; continue; fi
    other_marker=$([[ "$marker" == "12S" ]] && echo 16S || echo 12S)

    query="config/queries/query_${target}.txt"
    gb="data/raw/${target}.gb"
    fasta="data/processed/${target}/${target}.fasta"
    taxids="data/processed/${target}/${target}_taxids.txt"

    # --- query file ---
    logged=""
    if [[ -f "$query" ]]; then
        qtext="$(awk '/^BOOLEAN QUERY/ { f = 1; next } /^LOG/ { f = 0 } f' "$query")"
        if grep -qi "\b${marker}\b" <<< "$qtext"; then
            ok "query uses the term ${marker}"
        elif grep -qi "\b${other_marker}\b" <<< "$qtext"; then
            fail "query uses the term ${other_marker}, not ${marker}"
        else
            warn "query does not mention ${marker}"
        fi
        logged="$(grep -oP 'Sequences retrieved\s*:\s*\K[0-9]+' "$query" || true)"
    else
        warn "query file not found: $query"
    fi

    # --- GenBank file ---
    if [[ ! -s "$gb" ]]; then
        fail "GenBank file not found: $gb"
        continue
    fi
    genbank_summary "$gb" "$marker" > "$TMP/gb.tsv"
    n_gb=$(wc -l < "$TMP/gb.tsv")
    if [[ -n "$logged" && "$logged" != "$n_gb" ]]; then
        warn ".gb has ${n_gb} records, query log says ${logged}"
    else
        ok ".gb has ${n_gb} records"
    fi

    n_own=$(awk -F '\t' '$2 == "own"' "$TMP/gb.tsv" | wc -l)
    n_other=$(awk -F '\t' '$2 == "other"' "$TMP/gb.tsv" | wc -l)
    n_none=$(awk -F '\t' '$2 == "none"' "$TMP/gb.tsv" | wc -l)
    share=$(( n_gb > 0 ? 100 * n_own / n_gb : 0 ))
    if (( share >= MIN_MARKER_SHARE )); then
        ok "${share}% of records mention ${marker} (${n_own}/${n_gb})"
    else
        if (( n_other > n_own )); then
            fail "only ${share}% of records mention ${marker} (${n_own}/${n_gb}); ${n_other} mention only ${other_marker}"
        else
            warn "only ${share}% of records mention ${marker} (${n_own}/${n_gb}); ${n_other} only ${other_marker}, ${n_none} neither"
        fi
        awk -F '\t' '$2 != "own" && n++ < 3 { printf "          e.g. %s  %s\n", $1, substr($4, 1, 70) }' "$TMP/gb.tsv"
    fi
    n_mrna=$(awk -F '\t' '$3 == 1' "$TMP/gb.tsv" | wc -l)
    if (( n_mrna > 0 )); then
        warn "${n_mrna} mRNA records (nuclear/predicted genes), e.g. $(awk -F '\t' '$3 == 1 { print $1; exit }' "$TMP/gb.tsv")"
    fi
    cut -f1 "$TMP/gb.tsv" | sort -u > "$TMP/gb.acc"

    # --- FASTA file ---
    if [[ ! -s "$fasta" ]]; then
        fail "FASTA file not found: $fasta (run step 01)"
        continue
    fi
    grep '^>' "$fasta" | cut -d ' ' -f1 | cut -c2- | sed 's/\.[0-9]*$//' | sort -u > "$TMP/fa.acc"
    sed 's/\.[0-9]*$//' "$TMP/gb.acc" | sort -u > "$TMP/gb.acc.nover"
    n_fa=$(grep -c '^>' "$fasta")
    n_extra=$(comm -23 "$TMP/fa.acc" "$TMP/gb.acc.nover" | wc -l)
    if (( n_extra > 0 )); then
        fail "${n_extra} of ${n_fa} FASTA records are not in ${gb} (FASTA made from another .gb?)"
    else
        ok "FASTA has ${n_fa} records, all from the .gb file"
    fi

    # target species present?
    grep -o 'taxid=[0-9]*' "$fasta" | cut -d '=' -f2 | sort -u > "$TMP/fa.tax"
    n_root=$(grep -c "taxid=${root};" "$fasta" || true)
    if (( n_root > 0 )); then
        ok "target species (taxid ${root}) has ${n_root} sequence(s)"
    else
        fail "target species (taxid ${root}) has no sequence in the FASTA file"
    fi

    # --- taxid list ---
    if [[ ! -f "$taxids" ]]; then
        warn "taxid list not found: $taxids (run step 02)"
    else
        tr ',' '\n' <<< "$excluded" | sed '/^$/d' > "$TMP/excl"
        grep -vxFf "$TMP/excl" "$TMP/fa.tax" > "$TMP/expected" || true
        [[ -s "$TMP/excl" ]] || cp "$TMP/fa.tax" "$TMP/expected"
        if diff -q <(sort -u "$taxids") "$TMP/expected" > /dev/null; then
            ok "taxid list matches the FASTA file ($(wc -l < "$TMP/expected") taxids)"
        else
            warn "taxid list differs from the FASTA file (run step 02 again)"
        fi
    fi
    cp "$TMP/fa.acc" "$TMP/acc_${target}"
done

# --- 12S vs 16S of the same reference set ---
echo "=== 12S vs 16S pairs"
for target in "${TARGET_LIST[@]}"; do
    [[ "$target" == 12s_* ]] || continue
    pair="16s_${target#12s_}"
    a="$TMP/acc_${target}"
    b="$TMP/acc_${pair}"
    if [[ ! -f "$b" && -s "data/processed/${pair}/${pair}.fasta" ]]; then
        grep '^>' "data/processed/${pair}/${pair}.fasta" | cut -d ' ' -f1 | cut -c2- | sed 's/\.[0-9]*$//' | sort -u > "$b"
    fi
    [[ -f "$a" && -f "$b" ]] || continue
    n_a=$(wc -l < "$a")
    n_shared=$(comm -12 "$a" "$b" | wc -l)
    share=$(( n_a > 0 ? 100 * n_shared / n_a : 0 ))
    if (( share > MAX_OVERLAP_SHARE )); then
        fail "${target}: ${n_shared}/${n_a} accessions (${share}%) also in ${pair}"
    else
        ok "${target}: ${n_shared}/${n_a} accessions shared with ${pair} (complete mitogenomes are expected)"
    fi
done

echo
echo "Summary: ${N_FAIL} FAIL, ${N_WARN} WARN"
(( N_FAIL == 0 ))
