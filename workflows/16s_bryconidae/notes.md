# 16s_bryconidae

| | |
|---|---|
| Marker | 16S |
| Reference set | Bryconidae (family) |
| Target species (`-r`) | *Salminus hilarii* (taxid 932087) |
| Counterexample taxids (`-i`) | 33 (26 after the update) |
| Amplicon length | 150-300 bp |
| GenBank query | [`config/queries/query_16s_bryconidae.txt`](../../config/queries/query_16s_bryconidae.txt) |
| Sequences retrieved | 84 (75 after the update) |
| Species | 34 (27 after the update) |
| Commands | [`commands.sh`](commands.sh) |

## Results

Value recorded in the workflow notes for each ecoPrimers run (original dataset, now replaced; see the update below).

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

## Update (November 2026)

- Running ecoPrimers on the original dataset reproduces the values above, and its output matches the original spreadsheets row by row.
- The original query had unquoted species names, so each name was searched as separate words. It retrieved 9 records of unidentified or synonymous taxa: *Brycon* sp. (DC-2004, KTA-2014, UFRGS11377), *Brycon* aff. *atrocaudatus* KTA-2014, *Brycon* cf. *falcatus* KTA-2014, *Salminus* sp. KTA-2014 and *Salminus maxillosus*.
- The dataset was downloaded again in a single batch with the species names quoted and the same marker and taxonomic terms as the other 16S queries (`AND 16S AND "chordates"[porgn:__txid7711] AND "ray-finned fishes"[porgn:__txid7898]`; see `config/queries/query_16s_bryconidae.txt`): 75 records, 27 species. The 12 complete mitogenomes were reduced to the 16S region as annotated by NCBI. No mRNA records, nuclear chromosomes or hybrids were returned, and every taxid is present in the taxonomy used, so the counterexample list is all 26 non-target species.
- New ecoPrimers results (same parameters): 17616, 19453, 21257, 22209, 23367 and 24140 primer pairs for 20 to 25 bp. The output files produced in WSL and in an independent run are identical byte for byte.
- Pairs with dif 3 = 0 and class GG: 1, 9, 11, 12, 18 and 23 for 20 to 25 bp (original dataset: 0, 4, 5, 10, 17 and 21).

## Redone on 12 November 2026

All 8 designs were downloaded again on the same day, with the same query pattern and curation rules (see the README, "Data curation"), and ecoPrimers was run again with the same parameters.

- Dataset: 75 records, 27 taxa; identical, byte for byte, to the version redone on 12 November. See `config/queries/query_16s_bryconidae.txt`.
- Counterexample taxids (`-i`): 26.
- ecoPrimers pairs, 20 to 25 bp: 17616, 19453, 21257, 22209, 23367, 24140.
- Pairs with dif 3 = 0 and class GG (in silico PCR): 1, 9, 11, 12, 18, 23.
- The output files produced in WSL and in an independent run are identical byte for byte.
