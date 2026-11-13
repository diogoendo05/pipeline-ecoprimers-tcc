# 12s_iguacu

| | |
|---|---|
| Marker | 12S |
| Reference set | Iguacu River basin (ichthyofauna) |
| Target species (`-r`) | *Steindachneridion melanodermatum* (taxid 1000982) |
| Counterexample taxids (`-i`) | 14 |
| Amplicon length | 150-300 bp |
| GenBank query | [`config/queries/query_12s_iguacu.txt`](../../config/queries/query_12s_iguacu.txt) |
| Sequences retrieved | 143 |
| Species | 15 |
| Commands | [`commands.sh`](commands.sh) |

## Results

Value recorded in the workflow notes for each ecoPrimers run.

| Primer length | Output file | Recorded value |
|---|---|---:|
| 20 bp | `12s_iguacu_ecoprimers20.csv` | 63845 |
| 21 bp | `12s_iguacu_ecoprimers21.csv` | 66689 |
| 22 bp | `12s_iguacu_ecoprimers22.csv` | 69351 |
| 23 bp | `12s_iguacu_ecoprimers23.csv` | 71989 |
| 24 bp | `12s_iguacu_ecoprimers24.csv` | 74058 |
| 25 bp | `12s_iguacu_ecoprimers25.csv` | 75593 |

## Notes

- The taxid list was saved as `12s_taxids.txt` (renamed `12s_iguacu_taxids.txt` in this repository).

## Redone on 12 November 2026

All 8 designs were downloaded again on the same day, with the same query pattern and curation rules (see the README, "Data curation"), and ecoPrimers was run again with the same parameters.

- Dataset: 709 records, 88 taxa (original dataset: 143 records, from a query file with curly quotes and names without the opening quote). 306 mitochondrial genomes entered with their 12S region; 34 nuclear sequences longer than 30 kb, 35 mRNA records and 1 nuclear scaffold removed; 15 hybrid taxa excluded from the counterexamples. See `config/queries/query_12s_iguacu.txt`.
- Counterexample taxids (`-i`): 72.
- ecoPrimers pairs, 20 to 25 bp: 49246, 52922, 56285, 60094, 63158, 65849.
- Pairs with dif 3 = 0 and class GG (in silico PCR): 17, 26, 46, 48, 38, 53.
- The output files produced in WSL and in an independent run are identical byte for byte.
