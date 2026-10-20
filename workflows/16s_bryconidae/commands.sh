#!/usr/bin/env bash
# ------------------------------------------------------------------
# 16s_bryconidae: commands exactly as recorded in the workflow notes
# Source: Google Docs "Workflow ... (16s_bryconidae)", id 1cUtl9jnIm3X14uAT_cJwj524ZY-mRwxKhtQfhEyfIto
#
# RECORD ONLY - do not run. Paths and file names are the ones used at
# the time, in a WSL working folder that contained the .gb file and an
# NCBI taxdump folder named 'taxdump'. To reproduce the analysis use
#   bash scripts/run_all_targets.sh 16s_bryconidae
# ------------------------------------------------------------------

# Step 0 - GenBank query: see config/queries/query_16s_bryconidae.txt

# Step 1 - GenBank to FASTA
obiconvert --skip-on-error --genbank -t taxdump sequencias_fase1.gb --fasta-output > sequencias_fase1.fasta
obiconvert --skip-on-error --genbank -t taxdump sequencias_fase2.gb --fasta-output > sequencias_fase2.fasta
# (both FASTA files were merged into 16s_bryconidae.fasta; command not recorded)

# Step 2 - unique taxids
grep -i -o 'taxid=[0-9]*' 16s_bryconidae.fasta | cut -d '=' -f 2 | sort | uniq > 16s_bryconidae_taxids.txt

# Step 3 - remove the target species and build the -i list
grep -v '932087' 16s_bryconidae_taxids.txt | awk '{printf "-i %s ", $1}'

# Step 4 - ecoPCR database
python /home/diogo/miniconda3/envs/ecoprimers_env/bin/ecoPCRFormat.py --fasta --taxonomy taxdump --name banco_16s_bryconidae 16s_bryconidae.fasta

# Step 5 - ecoPrimers, primer length N = 20..25 bp (-3 N -O N)
ecoPrimers -d banco_16s_bryconidae -l 150 -L 300 -r 932087 -i 126311 -i 126312 -i 126315 -i 1463242 -i 1529838 -i 1529839 -i 1529840 -i 1529841 -i 1529842 -i 1529843 -i 1529844 -i 1529845 -i 1529848 -i 190791 -i 190792 -i 190793 -i 190794 -i 190795 -i 202829 -i 217208 -i 303983 -i 303985 -i 304083 -i 387479 -i 387480 -i 387481 -i 387482 -i 387483 -i 387484 -i 387485 -i 686976 -i 930266 -i 930267 -3 20 -U -O 20 > 16s_bryconidae_ecoprimers20.csv
ecoPrimers -d banco_16s_bryconidae -l 150 -L 300 -r 932087 -i 126311 -i 126312 -i 126315 -i 1463242 -i 1529838 -i 1529839 -i 1529840 -i 1529841 -i 1529842 -i 1529843 -i 1529844 -i 1529845 -i 1529848 -i 190791 -i 190792 -i 190793 -i 190794 -i 190795 -i 202829 -i 217208 -i 303983 -i 303985 -i 304083 -i 387479 -i 387480 -i 387481 -i 387482 -i 387483 -i 387484 -i 387485 -i 686976 -i 930266 -i 930267 -3 21 -U -O 21 > 16s_bryconidae_ecoprimers21.csv
ecoPrimers -d banco_16s_bryconidae -l 150 -L 300 -r 932087 -i 126311 -i 126312 -i 126315 -i 1463242 -i 1529838 -i 1529839 -i 1529840 -i 1529841 -i 1529842 -i 1529843 -i 1529844 -i 1529845 -i 1529848 -i 190791 -i 190792 -i 190793 -i 190794 -i 190795 -i 202829 -i 217208 -i 303983 -i 303985 -i 304083 -i 387479 -i 387480 -i 387481 -i 387482 -i 387483 -i 387484 -i 387485 -i 686976 -i 930266 -i 930267 -3 22 -U -O 22 > 16s_bryconidae_ecoprimers22.csv
ecoPrimers -d banco_16s_bryconidae -l 150 -L 300 -r 932087 -i 126311 -i 126312 -i 126315 -i 1463242 -i 1529838 -i 1529839 -i 1529840 -i 1529841 -i 1529842 -i 1529843 -i 1529844 -i 1529845 -i 1529848 -i 190791 -i 190792 -i 190793 -i 190794 -i 190795 -i 202829 -i 217208 -i 303983 -i 303985 -i 304083 -i 387479 -i 387480 -i 387481 -i 387482 -i 387483 -i 387484 -i 387485 -i 686976 -i 930266 -i 930267 -3 23 -U -O 23 > 16s_bryconidae_ecoprimers23.csv
ecoPrimers -d banco_16s_bryconidae -l 150 -L 300 -r 932087 -i 126311 -i 126312 -i 126315 -i 1463242 -i 1529838 -i 1529839 -i 1529840 -i 1529841 -i 1529842 -i 1529843 -i 1529844 -i 1529845 -i 1529848 -i 190791 -i 190792 -i 190793 -i 190794 -i 190795 -i 202829 -i 217208 -i 303983 -i 303985 -i 304083 -i 387479 -i 387480 -i 387481 -i 387482 -i 387483 -i 387484 -i 387485 -i 686976 -i 930266 -i 930267 -3 24 -U -O 24 > 16s_bryconidae_ecoprimers24.csv
ecoPrimers -d banco_16s_bryconidae -l 150 -L 300 -r 932087 -i 126311 -i 126312 -i 126315 -i 1463242 -i 1529838 -i 1529839 -i 1529840 -i 1529841 -i 1529842 -i 1529843 -i 1529844 -i 1529845 -i 1529848 -i 190791 -i 190792 -i 190793 -i 190794 -i 190795 -i 202829 -i 217208 -i 303983 -i 303985 -i 304083 -i 387479 -i 387480 -i 387481 -i 387482 -i 387483 -i 387484 -i 387485 -i 686976 -i 930266 -i 930267 -3 25 -U -O 25 > 16s_bryconidae_ecoprimers25.csv
