#!/usr/bin/env bash
# ------------------------------------------------------------------
# 12s_iguacu: commands exactly as recorded in the workflow notes
# Source: Google Docs "Workflow ... (12s_iguacu)", id 1OMeedZAT3pjEJ1QWdRqbLPOJxdlk76vsz8tYQfKR6V8
#
# RECORD ONLY - do not run. Paths and file names are the ones used at
# the time, in a WSL working folder that contained the .gb file and an
# NCBI taxdump folder named 'taxdump'. To reproduce the analysis use
#   bash scripts/run_all_targets.sh 12s_iguacu
# ------------------------------------------------------------------

# Step 0 - GenBank query: see config/queries/query_12s_iguacu.txt

# Step 1 - GenBank to FASTA
obiconvert --skip-on-error --genbank -t taxdump 12s_iguacu.gb --fasta-output > 12s_iguacu.fasta

# Step 2 - unique taxids
grep -i -o 'taxid=[0-9]*' 12s_iguacu.fasta | cut -d '=' -f 2 | sort | uniq > 12s_taxids.txt

# Step 3 - remove the target species and build the -i list
grep -v '1000982' 12s_taxids.txt | awk '{printf "-i %s ", $1}'

# Step 4 - ecoPCR database
python /home/diogo/miniconda3/envs/ecoprimers_env/bin/ecoPCRFormat.py --fasta --taxonomy taxdump --name banco_12s_iguacu 12s_iguacu.fasta

# Step 5 - ecoPrimers, primer length N = 20..25 bp (-3 N -O N)
ecoPrimers -d banco_12s_iguacu -l 150 -L 300 -r 1000982 -i 1123850 -i 1123855 -i 181452 -i 219752 -i 27695 -i 309911 -i 380998 -i 42528 -i 594006 -i 681897 -i 75329 -i 8081 -i 8084 -i 930266 -3 20 -U -O 20 > 12s_iguacu_ecoprimers20.csv
ecoPrimers -d banco_12s_iguacu -l 150 -L 300 -r 1000982 -i 1123850 -i 1123855 -i 181452 -i 219752 -i 27695 -i 309911 -i 380998 -i 42528 -i 594006 -i 681897 -i 75329 -i 8081 -i 8084 -i 930266 -3 21 -U -O 21 > 12s_iguacu_ecoprimers21.csv
ecoPrimers -d banco_12s_iguacu -l 150 -L 300 -r 1000982 -i 1123850 -i 1123855 -i 181452 -i 219752 -i 27695 -i 309911 -i 380998 -i 42528 -i 594006 -i 681897 -i 75329 -i 8081 -i 8084 -i 930266 -3 22 -U -O 22 > 12s_iguacu_ecoprimers22.csv
ecoPrimers -d banco_12s_iguacu -l 150 -L 300 -r 1000982 -i 1123850 -i 1123855 -i 181452 -i 219752 -i 27695 -i 309911 -i 380998 -i 42528 -i 594006 -i 681897 -i 75329 -i 8081 -i 8084 -i 930266 -3 23 -U -O 23 > 12s_iguacu_ecoprimers23.csv
ecoPrimers -d banco_12s_iguacu -l 150 -L 300 -r 1000982 -i 1123850 -i 1123855 -i 181452 -i 219752 -i 27695 -i 309911 -i 380998 -i 42528 -i 594006 -i 681897 -i 75329 -i 8081 -i 8084 -i 930266 -3 24 -U -O 24 > 12s_iguacu_ecoprimers24.csv
ecoPrimers -d banco_12s_iguacu -l 150 -L 300 -r 1000982 -i 1123850 -i 1123855 -i 181452 -i 219752 -i 27695 -i 309911 -i 380998 -i 42528 -i 594006 -i 681897 -i 75329 -i 8081 -i 8084 -i 930266 -3 25 -U -O 25 > 12s_iguacu_ecoprimers25.csv
