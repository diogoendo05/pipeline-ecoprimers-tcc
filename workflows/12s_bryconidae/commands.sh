#!/usr/bin/env bash
# ------------------------------------------------------------------
# 12s_bryconidae: commands exactly as recorded in the workflow notes
# Source: Google Docs "Workflow ... (12s_bryconidae)", id 1k0DjdDTou0lMw-M1Nj57L_qpzDv6Dhy5ysLU2sRDzXo
#
# RECORD ONLY - do not run. Paths and file names are the ones used at
# the time, in a WSL working folder that contained the .gb file and an
# NCBI taxdump folder named 'taxdump'. To reproduce the analysis use
#   bash scripts/run_all_targets.sh 12s_bryconidae
# ------------------------------------------------------------------

# Step 0 - GenBank query: see config/queries/query_12s_bryconidae.txt

# Step 1 - GenBank to FASTA
obiconvert --skip-on-error --genbank -t taxdump 12s_bryconidae.gb --fasta-output > 12s_bryconidae.fasta

# Step 2 - unique taxids
grep -i -o 'taxid=[0-9]*' 12s_bryconidae.fasta | cut -d '=' -f 2 | sort | uniq > 12s_bryconidae_taxids.txt

# Step 3 - remove the target species and build the -i list
grep -v '932087' 12s_bryconidae_taxids.txt | awk '{printf "-i %s ", $1}'

# Step 4 - ecoPCR database
python /home/diogo/miniconda3/envs/ecoprimers_env/bin/ecoPCRFormat.py --fasta --taxonomy taxdump --name banco_12s_bryconidae 12s_bryconidae.fasta

# Step 5 - ecoPrimers, primer length N = 20..25 bp (-3 N -O N)
ecoPrimers -d banco_12s_bryconidae -l 150 -L 300 -r 932087 -i 126315 -i 1463242 -i 1529838 -i 1633422 -i 190791 -i 190792 -i 190793 -i 190794 -i 190795 -i 3101989 -i 3101990 -i 3101991 -i 3101992 -i 387479 -i 387480 -i 387484 -i 387485 -i 686976 -i 930266 -3 20 -U -O 20 > 12s_bryconidae_ecoprimers20.csv
ecoPrimers -d banco_12s_bryconidae -l 150 -L 300 -r 932087 -i 126315 -i 1463242 -i 1529838 -i 1633422 -i 190791 -i 190792 -i 190793 -i 190794 -i 190795 -i 3101989 -i 3101990 -i 3101991 -i 3101992 -i 387479 -i 387480 -i 387484 -i 387485 -i 686976 -i 930266 -3 21 -U -O 21 > 12s_bryconidae_ecoprimers21.csv
ecoPrimers -d banco_12s_bryconidae -l 150 -L 300 -r 932087 -i 126315 -i 1463242 -i 1529838 -i 1633422 -i 190791 -i 190792 -i 190793 -i 190794 -i 190795 -i 3101989 -i 3101990 -i 3101991 -i 3101992 -i 387479 -i 387480 -i 387484 -i 387485 -i 686976 -i 930266 -3 22 -U -O 22 > 12s_bryconidae_ecoprimers22.csv
ecoPrimers -d banco_12s_bryconidae -l 150 -L 300 -r 932087 -i 126315 -i 1463242 -i 1529838 -i 1633422 -i 190791 -i 190792 -i 190793 -i 190794 -i 190795 -i 3101989 -i 3101990 -i 3101991 -i 3101992 -i 387479 -i 387480 -i 387484 -i 387485 -i 686976 -i 930266 -3 23 -U -O 23 > 12s_bryconidae_ecoprimers23.csv
ecoPrimers -d banco_12s_bryconidae -l 150 -L 300 -r 932087 -i 126315 -i 1463242 -i 1529838 -i 1633422 -i 190791 -i 190792 -i 190793 -i 190794 -i 190795 -i 3101989 -i 3101990 -i 3101991 -i 3101992 -i 387479 -i 387480 -i 387484 -i 387485 -i 686976 -i 930266 -3 24 -U -O 24 > 12s_bryconidae_ecoprimers24.csv
ecoPrimers -d banco_12s_bryconidae -l 150 -L 300 -r 932087 -i 126315 -i 1463242 -i 1529838 -i 1633422 -i 190791 -i 190792 -i 190793 -i 190794 -i 190795 -i 3101989 -i 3101990 -i 3101991 -i 3101992 -i 387479 -i 387480 -i 387484 -i 387485 -i 686976 -i 930266 -3 25 -U -O 25 > 12s_bryconidae_ecoprimers25.csv
