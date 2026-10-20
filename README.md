# pipeline-ecoprimers-tcc

In silico search for species-specific primers on the mitochondrial 12S and 16S rRNA genes, using OBITools 1.2.13 and ecoPrimers on GenBank reference sets of Neotropical freshwater fishes.


## Objective

This repository documents, step by step, the workflow used in my undergraduate thesis (TCC) to find candidate primer pairs for two target species:

- *Steindachneridion melanodermatum* (Pimelodidae; NCBI taxid 1000982), endemic to the Iguacu River basin;
- *Salminus hilarii* (Bryconidae; NCBI taxid 932087), present in the Tibagi River basin.

For each target species, ecoPrimers is run against two reference sets: the species' family and the ichthyofauna of the river basin where it occurs. The target species is the example group (`-r`) and every other species in the reference set is a counterexample (`-i`), so the candidate primers should amplify the target and avoid the co-occurring species. Each reference set is tested with 12S and 16S, giving 8 targets, and each target is run with primer lengths from 20 to 25 bp.


## Targets

The parameters of each target are in `config/targets.tsv`.

| target_id | marker | reference set | root_taxid (species) | min_len | max_len |
|-----------|--------|---------------|----------------------|---------|---------|
| 12s_pimelodidae | 12S | Pimelodidae (family) | 1000982 (*S. melanodermatum*) | 150 | 300 |
| 16s_pimelodidae | 16S | Pimelodidae (family) | 1000982 (*S. melanodermatum*) | 150 | 300 |
| 12s_bryconidae | 12S | Bryconidae (family) | 932087 (*S. hilarii*) | 150 | 300 |
| 16s_bryconidae | 16S | Bryconidae (family) | 932087 (*S. hilarii*) | 150 | 300 |
| 12s_tibagi | 12S | Tibagi River basin | 932087 (*S. hilarii*) | 150 | 300 |
| 16s_tibagi | 16S | Tibagi River basin | 932087 (*S. hilarii*) | 150 | 300 |
| 12s_iguacu | 12S | Iguacu River basin | 1000982 (*S. melanodermatum*) | 150 | 300 |
| 16s_iguacu | 16S | Iguacu River basin | 1000982 (*S. melanodermatum*) | 150 | 300 |


## Structure

```
config/targets.tsv        parameters of each target
config/queries/           GenBank boolean query and download log per target
data/taxdump/             NCBI names.dmp and nodes.dmp (shared, not versioned)
data/raw/                 .gb files exported from NCBI GenBank
data/processed/<target>/  FASTA, taxid list and ecoPCR database
scripts/                  steps 01-04 + main runner
results/<target>/         ecoPrimers output, one file per primer length
workflows/<target>/       commands as originally run + notes (record only)
```

`scripts/` is the reproducible pipeline; `workflows/` is the record of the commands as they were originally run for each test (see [`workflows/README.md`](workflows/README.md)).


## Workflow

| Step | Script | Tool | What it does |
|------|--------|------|--------------|
| 0 | (manual) | NCBI GenBank | Run the boolean query in `config/queries/` and export the records as `data/raw/<target>.gb` |
| 0 | `00_check_data.sh` | `awk`, `grep` | Check the downloaded data before running the pipeline (see below) |
| 1 | `01_convert_genbank.sh` | `obiconvert` | Convert GenBank to FASTA, adding `organism=` and `taxid=` to each header |
| 2 | `02_extract_taxids.sh` | `grep`, `cut`, `sort`, `uniq` | List the unique taxids in the FASTA file, minus any `excluded_taxids` |
| 3 | `03_format_ecopcr_db.sh` | `ecoPCRFormat.py` | Build the binary ecoPCR database used by ecoPrimers |
| 4 | `04_run_ecoprimers.sh` | `ecoPrimers` | Remove the target species from the taxid list, pass the remaining taxids as counterexamples and run ecoPrimers for primer lengths 20 to 25 bp |

Commands run in each step, for target `12s_iguacu`:

```bash
# 1
obiconvert --skip-on-error --genbank -t data/taxdump data/raw/12s_iguacu.gb --fasta-output \
    > data/processed/12s_iguacu/12s_iguacu.fasta

# 2
grep -i -o 'taxid=[0-9]*' data/processed/12s_iguacu/12s_iguacu.fasta | cut -d '=' -f 2 | sort | uniq \
    > data/processed/12s_iguacu/12s_iguacu_taxids.txt

# 3
python ecoPCRFormat.py --fasta --taxonomy data/taxdump --name data/processed/12s_iguacu/12s_iguacu_db \
    data/processed/12s_iguacu/12s_iguacu.fasta

# 4 (counterexamples = every taxid except the target species)
grep -v '1000982' data/processed/12s_iguacu/12s_iguacu_taxids.txt | awk '{printf "-i %s ", $1}'
ecoPrimers -d data/processed/12s_iguacu/12s_iguacu_db -l 150 -L 300 -r 1000982 -i 1123850 -i 1123855 ... \
    -3 20 -U -O 20 > results/12s_iguacu/12s_iguacu_ecoprimers20.csv
# repeated with -3 N -O N for N = 21, 22, 23, 24, 25
```


## Prerequisites

The pipeline was run on Ubuntu under WSL (Windows Subsystem for Linux) with:

- OBITools 1.2.13 (Python 2.7), for `obiconvert`
- ecoPCR, for `ecoPCRFormat.py`
- ecoPrimers
- NCBI taxonomy dump (`taxdump.tar.gz`)

1. Create and activate the conda environment:

   ```bash
   conda env create -f environment.yml
   conda activate ecoprimers_env
   ```

2. Download the NCBI taxonomy into `data/taxdump/`:

   ```bash
   wget -P data/taxdump https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdump.tar.gz
   tar -xzf data/taxdump/taxdump.tar.gz -C data/taxdump names.dmp nodes.dmp merged.dmp delnodes.dmp
   ```

3. If `ecoPCRFormat.py` is not in the `PATH`, point to it with:

   ```bash
   export ECOPCRFORMAT=$CONDA_PREFIX/bin/ecoPCRFormat.py
   ```


## How to run

All scripts are run from the repository root.

```bash
# check the input data first (all targets, or the ones given)
bash scripts/00_check_data.sh
bash scripts/00_check_data.sh 12s_tibagi

# all 8 targets, steps 01 to 04, with a summary table at the end
bash scripts/run_all_targets.sh

# selected targets only
bash scripts/run_all_targets.sh 12s_tibagi 16s_tibagi

# a single step for a single target
bash scripts/01_convert_genbank.sh 12s_pimelodidae
bash scripts/02_extract_taxids.sh 12s_pimelodidae
bash scripts/03_format_ecopcr_db.sh 12s_pimelodidae
bash scripts/04_run_ecoprimers.sh 12s_pimelodidae
```

The tool executables can be replaced through the environment variables `OBICONVERT`, `ECOPCRFORMAT`, `PYTHON` and `ECOPRIMERS`.

### Data check

`scripts/00_check_data.sh` only reads files and reports, for each target, `OK`, `WARN` (check by hand) or `FAIL` (the pipeline cannot run or the results would not be valid). It checks that:

- the GenBank query uses the marker of the target (12S or 16S);
- the number of `.gb` records matches the number logged in the query file;
- at least 80% of the `.gb` records mention the expected marker in the definition line or in an rRNA `/product`, and how many records are nuclear/predicted mRNA;
- every FASTA record comes from the target's `.gb` file;
- the target species (`root_taxid`) has at least one sequence;
- the taxid list matches the FASTA file (minus `excluded_taxids`);
- the 12S set of a reference set is not mostly the same records as its 16S set.

The exit code is 1 when there is any `FAIL`. The script does not run as part of `run_all_targets.sh`.


## Parameters

### `config/targets.tsv`

| Column | Meaning |
|--------|---------|
| `target_id` | Target name, `<marker>_<reference set>`. Used to name every file and folder |
| `marker` | Mitochondrial gene: 12S or 16S |
| `reference_set` | Group of species downloaded from GenBank (a family or the fish fauna of a river basin) |
| `root_taxid` | NCBI taxid of the target species, passed to ecoPrimers as `-r` |
| `root_species` | Name of the target species (documentation only) |
| `min_len` / `max_len` | Minimum and maximum amplicon length in bp, excluding the primers (`-l` / `-L`) |
| `excluded_taxids` | Optional, comma-separated. Taxids removed by hand from the taxid list in step 02, so they are neither examples nor counterexamples |

The amplicon range of 150-300 bp was used for all targets. The only manual exclusion is in `16s_iguacu` (taxids 1550064 and 2590590), which were removed from the list before the final ecoPrimers runs.

### ecoPrimers options

| Option | Value | Meaning |
|--------|-------|---------|
| `-d` | `<target>_db` | ecoPCR database built in step 03 |
| `-l` / `-L` | 150 / 300 | Minimum / maximum amplicon length |
| `-r` | `root_taxid` | Example group: only sequences of the target species are used to design the primers |
| `-i` | every other taxid | Counterexample groups that the primers should not amplify |
| `-O` | 20 to 25 | Primer length |
| `-3` | same as `-O` | Number of 3' bases that must match strictly; equal to the primer length, so the whole primer matches strictly |
| `-U` | flag | A primer cannot match the same sequence record more than once |
| `-e`, `-q`, `-s` | not set | Mismatches per primer and quorums are left at the ecoPrimers defaults |


## Results

Value recorded in the workflow notes for each ecoPrimers run.

| target_id | 20 bp | 21 bp | 22 bp | 23 bp | 24 bp | 25 bp |
|-----------|------:|------:|------:|------:|------:|------:|
| 12s_pimelodidae | 8167 | 8642 | 9238 | 9685 | 10132 | 10430 |
| 16s_pimelodidae | 19936 | 21723 | 23251 | 24483 | 26137 | 27766 |
| 12s_bryconidae | - | - | - | - | - | - |
| 16s_bryconidae | 16979 | 18789 | 20582 | 21499 | 22717 | 23530 |
| 12s_tibagi | 28377 | 30294 | 31840 | 33015 | 33637 | 34382 |
| 16s_tibagi | 27346 | 29271 | 31046 | 32418 | 33128 | 33966 |
| 12s_iguacu | 63845 | 66689 | 69351 | 71989 | 74058 | 75593 |
| 16s_iguacu | 134780 | 135070 | 135026 | 134905 | 134801 | 134627 |


## References

- Boyer F, Mercier C, Bonin A, Le Bras Y, Taberlet P, Coissac E. 2016. obitools: a unix-inspired software package for DNA metabarcoding. *Molecular Ecology Resources* 16(1): 176-182.
- Ficetola GF, Coissac E, Zundel S, Riaz T, Shehzad W, Bessière J, Taberlet P, Pompanon F. 2010. An in silico approach for the evaluation of DNA barcodes. *BMC Genomics* 11: 434.
- Riaz T, Shehzad W, Viari A, Pompanon F, Taberlet P, Coissac E. 2011. ecoPrimers: inference of new DNA barcode markers from whole genome sequence analysis. *Nucleic Acids Research* 39(21): e145.
- ecoPrimers manual: https://pythonhosted.org/OBITools/scripts/ecoPrimers.html
- NCBI Taxonomy: https://www.ncbi.nlm.nih.gov/taxonomy
