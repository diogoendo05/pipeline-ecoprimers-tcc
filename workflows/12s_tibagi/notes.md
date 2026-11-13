# 12s_tibagi

| | |
|---|---|
| Marker | 12S |
| Reference set | Tibagi River basin (ichthyofauna) |
| Target species (`-r`) | *Salminus hilarii* (taxid 932087) |
| Counterexample taxids (`-i`) | 109 |
| Amplicon length | 150-300 bp |
| GenBank query | [`config/queries/query_12s_tibagi.txt`](../../config/queries/query_12s_tibagi.txt) |
| Sequences retrieved | 454 |
| Species | not recorded |
| Commands | [`commands.sh`](commands.sh) |

## Results

Value recorded in the workflow notes for each ecoPrimers run (original dataset, now replaced; see the update below).

| Primer length | Output file | Recorded value |
|---|---|---:|
| 20 bp | `12s_tibagi_ecoprimers20.csv` | 28377 |
| 21 bp | `12s_tibagi_ecoprimers21.csv` | 30294 |
| 22 bp | `12s_tibagi_ecoprimers22.csv` | 31840 |
| 23 bp | `12s_tibagi_ecoprimers23.csv` | 33015 |
| 24 bp | `12s_tibagi_ecoprimers24.csv` | 33637 |
| 25 bp | `12s_tibagi_ecoprimers25.csv` | 34382 |

## Notes

- The step 1 note says the sequences went to `16s_tibagi.fasta`. This was later found to be accurate: the original `12s_tibagi.gb` had been exported from the 16S search (372 of its 454 records mentioned only 16S, and all 454 were also in `16s_tibagi`). The results above were therefore produced with 16S data.
- The query notes say the 12S of complete mitogenomes was downloaded for some species, but the species were not recorded ("??").

## Update (November 2026)

- The dataset was downloaded again with the same query and curated (see `config/queries/query_12s_tibagi.txt`): complete mitogenomes reduced to the NCBI-annotated 12S region (including KX371345), 13 nuclear mRNA records removed, and records KU980144 and OP218849, merged by a copy/paste error in the downloaded file, restored from their own GenBank files. Final file: 353 records, 94 species.
- The new dataset had no sequence of the target species. The only 12S reference of *Salminus hilarii* in GenBank, MZ778840 (219 bp), is annotated as "small subunit ribosomal RNA" and is not retrieved by the term "12S". It was added by hand. Without it, ecoPrimers stopped with a segmentation fault ("0 examples").
- ecoPrimers was run with the same parameters as the other targets (`-l 150 -L 300 -r 932087 -3 N -U -O N`, N = 20 to 25). It found **0 primer pairs** for every primer length. The amplicon of at least 150 bp only fits if the primers sit at the ends of the 219-bp reference, which are the conserved MiFish primer sites (for example, `AAACTCGTGCCAGCCACCGC` matches 99 non-target sequences and `AAACTGGGATTAGATACCCC` 264). Primers specific to the target exist only in the middle of the sequence, where no 150-bp amplicon fits.
- Output files: `results/12s_tibagi/12s_tibagi_ecoprimers20.csv` to `25.csv`.

## Redone on 12 November 2026

All 8 designs were downloaded again on the same day, with the same query pattern and curation rules (see the README, "Data curation"), and ecoPrimers was run again with the same parameters.

- Dataset: 403 records (with MZ778840), 102 taxa. Compared with the version of early November: 51 more mitochondrial genomes of Tibagi species, entered with their 12S region; *Brycon nattereri* added (the list had the misspelling "Brycon natterer", which retrieves nothing); AF072153 (*Sternopygus macrurus* 16S) removed. See `config/queries/query_12s_tibagi.txt`.
- Counterexample taxids (`-i`): 101.
- ecoPrimers pairs, 20 to 25 bp: 0 for every length (MZ778840 is too short, see the README).
- Pairs with dif 3 = 0 and class GG (in silico PCR): 0 for every length.
- The output files produced in WSL and in an independent run are identical byte for byte.
