# 16s_bryconidae

| | |
|---|---|
| Marker | 16S |
| Reference set | Bryconidae (family) |
| Target species (`-r`) | *Salminus hilarii* (taxid 932087) |
| Counterexample taxids (`-i`) | 33 |
| Amplicon length | 150-300 bp |
| GenBank query | [`config/queries/query_16s_bryconidae.txt`](../../config/queries/query_16s_bryconidae.txt) |
| Sequences retrieved | 84 |
| Species | 34 |
| Commands | [`commands.sh`](commands.sh) |

## Results

Value recorded in the workflow notes for each ecoPrimers run.

| Primer length | Output file | Recorded value |
|---|---|---:|
| 20 bp | `16s_bryconidae_ecoprimers20.csv` | 16979 |
| 21 bp | `16s_bryconidae_ecoprimers21.csv` | 18789 |
| 22 bp | `16s_bryconidae_ecoprimers22.csv` | 20582 |
| 23 bp | `16s_bryconidae_ecoprimers23.csv` | 21499 |
| 24 bp | `16s_bryconidae_ecoprimers24.csv` | 22717 |
| 25 bp | `16s_bryconidae_ecoprimers25.csv` | 23530 |

## Notes

- The 16S region of the complete mitogenomes of *Salminus brasiliensis*, *Brycon henni*, *Brycon nattereri* and *Brycon orbignyanus* was added to the GenBank records.
- The records were downloaded in two batches (`sequencias_fase1.gb`, `sequencias_fase2.gb`), converted separately and merged into `16s_bryconidae.fasta`. The merge command was not recorded.
