# 16s_iguacu

| | |
|---|---|
| Marker | 16S |
| Reference set | Iguacu River basin (ichthyofauna) |
| Target species (`-r`) | *Steindachneridion melanodermatum* (taxid 1000982) |
| Counterexample taxids (`-i`) | 16 |
| Amplicon length | 150-300 bp |
| GenBank query | [`config/queries/query_16s_iguacu.txt`](../../config/queries/query_16s_iguacu.txt) |
| Sequences retrieved | 212 |
| Species | 19 |
| Commands | [`commands.sh`](commands.sh) |

## Results

Value recorded in the workflow notes for each ecoPrimers run.

| Primer length | Output file | Recorded value |
|---|---|---:|
| 20 bp | `16s_iguacu_ecoprimers20` | 134780 |
| 21 bp | `16s_iguacu_ecoprimers21` | 135070 |
| 22 bp | `16s_iguacu_ecoprimers22` | 135026 |
| 23 bp | `16s_iguacu_ecoprimers23` | 134905 |
| 24 bp | `16s_iguacu_ecoprimers24` | 134801 |
| 25 bp | `16s_iguacu_ecoprimers25` | 134627 |

## Notes

- Steps 2 and 4 read `16s_iguacu_definitivo.fasta` instead of the `16s_iguacu.fasta` written in step 1. How the final FASTA was produced was not recorded.
- A first ecoPrimers run (20 bp) included taxids 1550064 and 2590590 as counterexamples; its note says "155 sequencias". These two taxids were removed for the six final runs (`excluded_taxids` in `config/targets.tsv`).
- The taxid list was saved as `16s_taxids.txt`, and the ecoPrimers outputs were saved without the `.csv` extension.
