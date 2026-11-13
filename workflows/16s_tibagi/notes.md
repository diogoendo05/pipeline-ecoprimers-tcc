# 16s_tibagi

| | |
|---|---|
| Marker | 16S |
| Reference set | Tibagi River basin (ichthyofauna) |
| Target species (`-r`) | *Salminus hilarii* (taxid 932087) |
| Counterexample taxids (`-i`) | 116 |
| Amplicon length | 150-300 bp |
| GenBank query | [`config/queries/query_16s_tibagi.txt`](../../config/queries/query_16s_tibagi.txt) |
| Sequences retrieved | 510 |
| Species | 117 |
| Commands | [`commands.sh`](commands.sh) |

## Results

Value recorded in the workflow notes for each ecoPrimers run.

| Primer length | Output file | Recorded value |
|---|---|---:|
| 20 bp | `16s_tibagi_ecoprimers20.csv` | 27346 |
| 21 bp | `16s_tibagi_ecoprimers21.csv` | 29271 |
| 22 bp | `16s_tibagi_ecoprimers22.csv` | 31046 |
| 23 bp | `16s_tibagi_ecoprimers23.csv` | 32418 |
| 24 bp | `16s_tibagi_ecoprimers24.csv` | 33128 |
| 25 bp | `16s_tibagi_ecoprimers25.csv` | 33966 |

## Notes

- The query notes say the 16S of complete mitogenomes was downloaded for some species, but the species were not recorded ("??").

## Redone on 12 November 2026

All 8 designs were downloaded again on the same day, with the same query pattern and curation rules (see the README, "Data curation"), and ecoPrimers was run again with the same parameters.

- Dataset: 464 records, 117 taxa (original dataset: 510-517 records). The 71 mitochondrial genomes now enter with their 16S region only (53 had entered as whole genomes); 33 records of other markers (32 *Clarias gariepinus* "small subunit" records and AF072139, *Sternopygus macrurus* 12S) and 5 mRNA records removed; *Brycon nattereri* added (misspelled "Brycon natterer" in the list); hybrid taxon 1630651 excluded from the counterexamples. See `config/queries/query_16s_tibagi.txt`.
- Counterexample taxids (`-i`): 115.
- ecoPrimers pairs, 20 to 25 bp: 27594, 28648, 30302, 31661, 32428, 33141.
- Pairs with dif 3 = 0 and class GG (in silico PCR): 18, 22, 19, 26, 32, 29.
- A second, independent run of the whole procedure produced the same output files byte for byte (WSL check pending).
