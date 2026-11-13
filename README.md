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
results/<target>/         ecoPrimers output (.csv) and spreadsheets (.xlsx), one per primer length
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
| 5 | `05_select_pairs.sh` | `awk` | Keep the pairs with dif 3 = 0 and class GG and decide which runs go to the in silico PCR (see below) |

### Data curation (between steps 0 and 1)

All 8 datasets were downloaded again on 12 November 2026 and curated with the same rules. Each target's query file in `config/queries/` logs the numbers for its data.

- **Query.** Every query has the same pattern: the species names in quotes, joined with `OR`, then `AND 12S` (or `AND 16S`) `AND "chordates"[porgn:__txid7711] AND "ray-finned fishes"[porgn:__txid7898]`. The Pimelodidae and Bryconidae lists are shared by the 12S and 16S designs, and so are the Iguacu and Tibagi lists.
- **Complete or partial mitochondrial genomes** (records longer than 3000 bp) are reduced to the region of the target gene (12S or 16S), using the coordinates of the rRNA feature as annotated by NCBI. The region is downloaded as a GenBank subrange, so the record keeps the line `ACCESSION <accession> REGION: <start>..<end>`.
- **Nuclear sequences** are removed: chromosomes and other records longer than 30 kb, nuclear mRNA records, and longer records that have no annotated 12S/16S feature. The query retrieves them only because a gene name contains "12S" or "16S" (for example *mettl15*, "12S rRNA N4-cytidine methyltransferase").
- **Records of another marker** are removed: records that mention the target marker neither in the DEFINITION line nor in an rRNA, gene or misc feature. They are retrieved only because the title of a reference mentions the marker (for example cytochrome b, D-loop or "small subunit" records in a 16S dataset).
- **Hybrid taxa** (organism names with " x ") stay in the database but are excluded from the counterexamples through `excluded_taxids` in `config/targets.tsv`.
- **Taxids missing from the taxonomy** are also added to `excluded_taxids` (see Parameters).
- **The 12S reference of *Salminus hilarii*** is added by hand. GenBank has a single 12S sequence of the species, MZ778840 (219 bp). It is annotated as "small subunit ribosomal RNA", not "12S", so the queries do not retrieve it. It is included in `12s_tibagi` and `12s_bryconidae`.

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

# 4 (counterexamples = every taxid except the target species; the taxid list of step 2 no longer has the excluded_taxids)
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

The amplicon range of 150-300 bp was used for all targets. Exclusions (`excluded_taxids`) are needed in three targets: `16s_tibagi` (1 hybrid taxon), `12s_iguacu` (15 hybrid taxa) and `16s_iguacu` (16 hybrid taxa and taxid 3738817, which is newer than the NCBI taxonomy dump used). The original `16s_iguacu` run already excluded the two *Misgurnus* hybrids, 1550064 and 2590590.

**Taxids missing from the taxonomy.** If a record's taxid does not exist in the taxonomy dump, `ecoPCRFormat.py` drops the record ("Skipped entry"), but the taxid still reaches the `-i` list, because the list is built from the FASTA file. ecoPrimers then counts the pairs and crashes with a segmentation fault while writing the output header. Such taxids must be added to `excluded_taxids`.

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

The ecoPrimers default for `-e` is 3 mismatches per primer, but since `-3` is equal to the primer length, a primer only counts as matching a sequence when the whole primer matches it strictly.

### Pair selection for the in silico PCR (step 05)

Only pairs that pass both filters below are tested with ecoPCR. These are the same filters used in the spreadsheets (column J = 0 and column M = GG):

| Filter | Columns of the ecoPrimers output | Rule |
|--------|----------------------------------|------|
| dif 3 | 5 (minimum Tm of the forward primer) and 7 (minimum Tm of the reverse primer) | equal (difference = 0) |
| class | 10 | `GG` |

**A run (target and primer length, for example `16s_pimelodidae` 21 bp) with no pair passing both filters is not tested with ecoPCR.** It is recorded as "not tested: no pair passed dif3=0 and GG".

`scripts/05_select_pairs.sh` writes `results/insilico_selection.tsv` (one line per run) and `results/insilico_selected_pairs.tsv` (the pairs that passed):

| target_id | 20 bp | 21 bp | 22 bp | 23 bp | 24 bp | 25 bp |
|-----------|------:|------:|------:|------:|------:|------:|
| 12s_pimelodidae | 0 | 0 | 0 | 0 | 0 | 0 |
| 16s_pimelodidae | 1 | 0 | 0 | 0 | 0 | 0 |
| 12s_bryconidae | 0 | 0 | 0 | 0 | 0 | 0 |
| 16s_bryconidae | 1 | 9 | 11 | 12 | 18 | 23 |
| 12s_tibagi | 0 | 0 | 0 | 0 | 0 | 0 |
| 16s_tibagi | 18 | 22 | 19 | 26 | 32 | 29 |
| 12s_iguacu | 17 | 26 | 46 | 48 | 38 | 53 |
| 16s_iguacu | 151 | 169 | 200 | 233 | 231 | 225 |

Pairs with dif 3 = 0 and class GG; 0 = not tested. In total, 25 of the 48 runs are tested, with 1658 pairs.

### ecoPCR

The candidate primer pairs are tested with ecoPCR against the same database built in step 03:

```bash
ecoPCR -d data/processed/<target>/<target>_db -k -e 3 -l 50 -L 300 <forward primer> <reverse primer> > <output>.txt
```

`-e 3` allows up to 3 mismatches per primer, so non-target species that would be amplified with imperfect matches also appear. The `-k` flag is required with the NCBI taxonomy distributed since 2025, which replaced the rank "superkingdom" by "domain". Without it, ecoPCR stops with `Rank label not found` (ecorank.c line 43), because by default it looks up the superkingdom of each sequence. With `-k`, columns 11-12 of the output show the kingdom (Metazoa) instead; the amplified sequences and mismatches are the same.


## Results

Number of primer pairs found by ecoPrimers in each run (the `Total good pair count` it reports).

| target_id | 20 bp | 21 bp | 22 bp | 23 bp | 24 bp | 25 bp | Dataset |
|-----------|------:|------:|------:|------:|------:|------:|---------|
| 12s_pimelodidae | 7573 | 8195 | 8642 | 9089 | 9685 | 10132 | 12 Nov 2026 |
| 16s_pimelodidae | 14818 | 16763 | 18058 | 19338 | 20603 | 21852 | 12 Nov 2026 |
| 12s_bryconidae | 0 | 0 | 0 | 0 | 0 | 0 | 12 Nov 2026 |
| 16s_bryconidae | 17616 | 19453 | 21257 | 22209 | 23367 | 24140 | 12 Nov 2026 |
| 12s_tibagi | 0 | 0 | 0 | 0 | 0 | 0 | 12 Nov 2026 |
| 16s_tibagi | 27594 | 28648 | 30302 | 31661 | 32428 | 33141 | 12 Nov 2026 |
| 12s_iguacu | 49246 | 52922 | 56285 | 60094 | 63158 | 65849 | 12 Nov 2026 |
| 16s_iguacu | 92403 | 96628 | 99782 | 102884 | 105746 | 108653 | 12 Nov 2026 |
**12S of *Salminus hilarii* (`12s_bryconidae`, `12s_tibagi`): no primer pair.** The only 12S reference of the target species, MZ778840, is 219 bp long and is a complete MiFish amplicon. With primers of 20 bp and amplicons of at least 150 bp, the primers would have to sit at the ends of that sequence, which are the conserved MiFish primer sites shared by dozens to hundreds of non-target sequences. The variable regions that could hold specific primers are in the middle of the sequence, where there is no room for an amplicon of 150-300 bp. So, with the parameters used for every other target, no species-specific 12S primers can be designed for *S. hilarii* from the public data.

**All 8 datasets redone on 12 November 2026.** Every dataset was downloaded again on the same day, with the same query pattern and curation rules, and all 48 runs were repeated with the same parameters. The same procedure run again from the curated files, in WSL and in an independent run, produced the same 48 output files, byte for byte. Compared with the earlier versions:

- `12s_pimelodidae`, `16s_pimelodidae`, `12s_bryconidae` and `16s_bryconidae`: the downloads were identical, byte for byte, to the versions already redone earlier in November 2026, and so were the 24 output files.
- `16s_iguacu`: same download as the version redone on 9-10 November; 40 records of other markers were removed (32 *Clarias gariepinus* "small subunit" records, 7 cytochrome b and 1 D-loop record).
- `12s_iguacu` (original dataset: 143 records, from a query file with curly quotes and names without the opening quote): now 709 records, with the mitogenomes reduced to the 12S region, the mRNA records removed and the hybrid taxa excluded.
- `16s_tibagi` (original dataset): the 71 mitogenomes now enter with their 16S region only (53 entered as whole genomes before), 33 records of other markers and 5 mRNA records were removed, and 1 hybrid taxon was excluded.
- `12s_tibagi`: now 403 records; the mitogenomes of the Tibagi species are included with their 12S region, and 1 16S record was removed. It still gives no primer pair (see above).
- `12s_tibagi` and `16s_tibagi`: "Brycon natterer" in the species list was corrected to *Brycon nattereri*; the misspelled name retrieves nothing, the correct one adds 3 (12S) and 7 (16S) records of this congener of the target's family.
- Earlier values: `16s_pimelodidae` 19936-27766 (dataset built with the 12S query), `12s_pimelodidae` 8167-10430 (unquoted names), `16s_bryconidae` 16979-23530 (unquoted names), `16s_tibagi` 27346-33966, `12s_iguacu` 63845-75593, `16s_iguacu` about 135,000 (target entered as its whole mitogenome) and then 92936-109125.

### Known issues

- **All four 12S queries** use the term "12S" and do not retrieve 12S records annotated only as "small subunit ribosomal RNA". Only MZ778840, the target species' reference, was added by hand.
- **`12s_pimelodidae`**: because of the term above, the congener *Steindachneridion amblyurum* (3 records annotated as "small subunit ribosomal RNA") is not among the counterexamples. It was left out to keep the same query pattern as the other 12S designs.


## References

- Boyer F, Mercier C, Bonin A, Le Bras Y, Taberlet P, Coissac E. 2016. obitools: a unix-inspired software package for DNA metabarcoding. *Molecular Ecology Resources* 16(1): 176-182.
- Ficetola GF, Coissac E, Zundel S, Riaz T, Shehzad W, Bessière J, Taberlet P, Pompanon F. 2010. An in silico approach for the evaluation of DNA barcodes. *BMC Genomics* 11: 434.
- Riaz T, Shehzad W, Viari A, Pompanon F, Taberlet P, Coissac E. 2011. ecoPrimers: inference of new DNA barcode markers from whole genome sequence analysis. *Nucleic Acids Research* 39(21): e145.
- ecoPrimers manual: https://pythonhosted.org/OBITools/scripts/ecoPrimers.html
- NCBI Taxonomy: https://www.ncbi.nlm.nih.gov/taxonomy
