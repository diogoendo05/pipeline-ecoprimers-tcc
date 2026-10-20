#!/usr/bin/env bash
# ------------------------------------------------------------------
# 16s_iguacu: commands exactly as recorded in the workflow notes
# Source: Google Docs "Workflow ... (16s_iguacu)", id 1zSnaJow8aYhZn1PqnYpfJpXxphkLiGLJZq6RUWMwqvc
#
# RECORD ONLY - do not run. Paths and file names are the ones used at
# the time, in a WSL working folder that contained the .gb file and an
# NCBI taxdump folder named 'taxdump'. To reproduce the analysis use
#   bash scripts/run_all_targets.sh 16s_iguacu
# ------------------------------------------------------------------

# Step 0 - GenBank query: see config/queries/query_16s_iguacu.txt

# Step 1 - GenBank to FASTA
obiconvert --skip-on-error --genbank -t taxdump 16s_iguacu.gb --fasta-output > 16s_iguacu.fasta

# Step 2 - unique taxids
grep -i -o 'taxid=[0-9]*' 16s_iguacu_definitivo.fasta | cut -d '=' -f 2 | sort | uniq > 16s_taxids.txt

# Step 3 - remove the target species and build the -i list
grep -v '1000982' 16s_taxids.txt | awk '{printf "-i %s ", $1}'

# Step 4 - ecoPCR database
python /home/diogo/miniconda3/envs/ecoprimers_env/bin/ecoPCRFormat.py --fasta --taxonomy taxdump --name banco_16s_iguacu 16s_iguacu_definitivo.fasta

# Step 5 - ecoPrimers, primer length N = 20..25 bp (-3 N -O N)
# first run, later replaced (taxids 1550064 and 2590590 still included)
/home/diogo/miniconda3/envs/ecoprimers_env/bin/ecoPrimers -d banco_16s_iguacu -l 150 -L 300 -r 1000982 -i 1123855 -i 1165829 -i 1550064 -i 181452 -i 219752 -i 252593 -i 2590590 -i 27695 -i 309911 -i 380998 -i 42528 -i 43700 -i 594006 -i 681897 -i 75329 -i 8081 -i 8084 -i 930266 -3 20 -U -O 20 > 16s_iguacu_ecoprimers

ecoPrimers -d banco_16s_iguacu -l 150 -L 300 -r 1000982 -i 1123855 -i 1165829 -i 181452 -i 219752 -i 252593 -i 27695 -i 309911 -i 380998 -i 42528 -i 43700 -i 594006 -i 681897 -i 75329 -i 8081 -i 8084 -i 930266 -3 20 -U -O 20 > 16s_iguacu_ecoprimers20
ecoPrimers -d banco_16s_iguacu -l 150 -L 300 -r 1000982 -i 1123855 -i 1165829 -i 181452 -i 219752 -i 252593 -i 27695 -i 309911 -i 380998 -i 42528 -i 43700 -i 594006 -i 681897 -i 75329 -i 8081 -i 8084 -i 930266 -3 21 -U -O 21 > 16s_iguacu_ecoprimers21
ecoPrimers -d banco_16s_iguacu -l 150 -L 300 -r 1000982 -i 1123855 -i 1165829 -i 181452 -i 219752 -i 252593 -i 27695 -i 309911 -i 380998 -i 42528 -i 43700 -i 594006 -i 681897 -i 75329 -i 8081 -i 8084 -i 930266 -3 22 -U -O 22 > 16s_iguacu_ecoprimers22
ecoPrimers -d banco_16s_iguacu -l 150 -L 300 -r 1000982 -i 1123855 -i 1165829 -i 181452 -i 219752 -i 252593 -i 27695 -i 309911 -i 380998 -i 42528 -i 43700 -i 594006 -i 681897 -i 75329 -i 8081 -i 8084 -i 930266 -3 23 -U -O 23 > 16s_iguacu_ecoprimers23
ecoPrimers -d banco_16s_iguacu -l 150 -L 300 -r 1000982 -i 1123855 -i 1165829 -i 181452 -i 219752 -i 252593 -i 27695 -i 309911 -i 380998 -i 42528 -i 43700 -i 594006 -i 681897 -i 75329 -i 8081 -i 8084 -i 930266 -3 24 -U -O 24 > 16s_iguacu_ecoprimers24
ecoPrimers -d banco_16s_iguacu -l 150 -L 300 -r 1000982 -i 1123855 -i 1165829 -i 181452 -i 219752 -i 252593 -i 27695 -i 309911 -i 380998 -i 42528 -i 43700 -i 594006 -i 681897 -i 75329 -i 8081 -i 8084 -i 930266 -3 25 -U -O 25 > 16s_iguacu_ecoprimers25
