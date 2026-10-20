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

Value recorded in the workflow notes for each ecoPrimers run.

| Primer length | Output file | Recorded value |
|---|---|---:|
| 20 bp | `12s_tibagi_ecoprimers20.csv` | 28377 |
| 21 bp | `12s_tibagi_ecoprimers21.csv` | 30294 |
| 22 bp | `12s_tibagi_ecoprimers22.csv` | 31840 |
| 23 bp | `12s_tibagi_ecoprimers23.csv` | 33015 |
| 24 bp | `12s_tibagi_ecoprimers24.csv` | 33637 |
| 25 bp | `12s_tibagi_ecoprimers25.csv` | 34382 |

## Notes

- The step 1 note says the sequences went to `16s_tibagi.fasta`; this looks like a copy from the 16S document, since the command writes `12s_tibagi.fasta`.
- The query notes say the 12S of complete mitogenomes was downloaded for some species, but the species were not recorded ("??").
