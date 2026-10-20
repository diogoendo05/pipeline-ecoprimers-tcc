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

Value recorded in the workflow notes for each ecoPrimers run.

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