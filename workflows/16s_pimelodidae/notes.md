# 16s_pimelodidae

| | |
|---|---|
| Marker | 16S |
| Reference set | Pimelodidae (family) |
| Target species (`-r`) | *Steindachneridion melanodermatum* (taxid 1000982) |
| Counterexample taxids (`-i`) | 81 |
| Amplicon length | 150-300 bp |
| GenBank query | [`config/queries/query_16s_pimelodidae.txt`](../../config/queries/query_16s_pimelodidae.txt) |
| Sequences retrieved | 184 |
| Species | 82 |
| Commands | [`commands.sh`](commands.sh) |

## Results

Value recorded in the workflow notes for each ecoPrimers run.

| Primer length | Output file | Recorded value |
|---|---|---:|
| 20 bp | `16s_pimelodidae_ecoprimers20.csv` | 19936 |
| 21 bp | `16s_pimelodidae_ecoprimers21.csv` | 21723 |
| 22 bp | `16s_pimelodidae_ecoprimers22.csv` | 23251 |
| 23 bp | `16s_pimelodidae_ecoprimers23.csv` | 24483 |
| 24 bp | `16s_pimelodidae_ecoprimers24.csv` | 26137 |
| 25 bp | `16s_pimelodidae_ecoprimers25.csv` | 27766 |

## Notes

- The GenBank query for this test uses the term `12S`, not `16S` (see `config/queries/query_16s_pimelodidae.txt`). The taxid list is identical to the one of `12s_pimelodidae`.
- The step 1 note says the sequences went to `16s_tibagi.fasta`; this looks like a copy from another document, since the command writes `16s_pimelodidae.fasta`.
- In the step 4 command a space is missing between `python` and the script path, as recorded.
- The query notes say the 12S of complete mitogenomes was downloaded for some species, but the species were not recorded ("??").
