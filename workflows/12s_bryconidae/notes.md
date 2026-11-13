# 12s_bryconidae

| | |
|---|---|
| Marker | 12S |
| Reference set | Bryconidae (family) |
| Target species (`-r`) | *Salminus hilarii* (taxid 932087) |
| Counterexample taxids (`-i`) | 19 |
| Amplicon length | 150-300 bp |
| GenBank query | [`config/queries/query_12s_bryconidae.txt`](../../config/queries/query_12s_bryconidae.txt) |
| Sequences retrieved | 84 |
| Species | 34 |
| Commands | [`commands.sh`](commands.sh) |

## Results

Value recorded in the workflow notes for each ecoPrimers run (original dataset, now replaced; see the update below).

| Primer length | Output file | Recorded value |
|---|---|---:|
| 20 bp | `12s_bryconidae_ecoprimers20.csv` | not recorded |
| 21 bp | `12s_bryconidae_ecoprimers21.csv` | 18789 |
| 22 bp | `12s_bryconidae_ecoprimers22.csv` | 20582 |
| 23 bp | `12s_bryconidae_ecoprimers23.csv` | 21499 |
| 24 bp | `12s_bryconidae_ecoprimers24.csv` | 22717 |
| 25 bp | `12s_bryconidae_ecoprimers25.csv` | 23530 |

## Notes

- The result values recorded for 21 to 25 bp are identical to those of `16s_bryconidae`, and no value was recorded for 20 bp. They are probably a copy and must be checked against the output files.
- The query notes (84 sequences, 34 species, and an incomplete sentence about complete mitogenomes) are the same as in `16s_bryconidae`.
- The repository has no FASTA or taxid file for this test, and `data/raw/12s_bryconidae.gb` has 30 records.

## Update (November 2026)

- The original download did not contain any 12S sequence of the target species, so this test could not have produced results; the values above were most likely copied from `16s_bryconidae`.
- The dataset was downloaded again with the species names quoted and curated (see `config/queries/query_12s_bryconidae.txt`): 12 complete mitogenomes reduced to the NCBI-annotated 12S region, 2 nuclear mRNA records and 2 nuclear chromosomes of *Salminus brasiliensis* removed, and MZ778840 (*S. hilarii*, 219 bp, the only 12S reference of the species) added by hand. Final file: 30 records, 14 species.
- ecoPrimers was run with the same parameters as the other targets (`-l 150 -L 300 -r 932087 -3 N -U -O N`, N = 20 to 25). It found **0 primer pairs** for every primer length, for the same reason as in `12s_tibagi`: the 219-bp reference only fits a 150-bp amplicon with primers on its conserved ends.
- Output files: `results/12s_bryconidae/12s_bryconidae_ecoprimers20.csv` to `25.csv`.

## Redone on 12 November 2026

All 8 designs were downloaded again on the same day, with the same query pattern and curation rules (see the README, "Data curation"), and ecoPrimers was run again with the same parameters.

- Dataset: 30 records (with MZ778840), 14 taxa; identical, byte for byte, to the version redone on 3-4 November. See `config/queries/query_12s_bryconidae.txt`.
- Counterexample taxids (`-i`): 13.
- ecoPrimers pairs, 20 to 25 bp: 0 for every length.
- Pairs with dif 3 = 0 and class GG (in silico PCR): 0 for every length.
- A second, independent run of the whole procedure produced the same output files byte for byte (WSL check pending).
