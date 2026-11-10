# 12s_pimelodidae

| | |
|---|---|
| Marker | 12S |
| Reference set | Pimelodidae (family) |
| Target species (`-r`) | *Steindachneridion melanodermatum* (taxid 1000982) |
| Counterexample taxids (`-i`) | 81 (51 after the update) |
| Amplicon length | 150-300 bp |
| GenBank query | [`config/queries/query_12s_pimelodidae.txt`](../../config/queries/query_12s_pimelodidae.txt) |
| Sequences retrieved | 188 (130 after the update) |
| Species | 82 (52 after the update) |
| Commands | [`commands.sh`](commands.sh) |

## Results

Value recorded in the workflow notes for each ecoPrimers run (original dataset, now replaced; see the update below).

| Primer length | Output file | Recorded value |
|---|---|---:|
| 20 bp | `12s_pimelodidae_ecoprimers20.csv` | 8167 |
| 21 bp | `12s_pimelodidae_ecoprimers21.csv` | 8642 |
| 22 bp | `12s_pimelodidae_ecoprimers22.csv` | 9238 |
| 23 bp | `12s_pimelodidae_ecoprimers23.csv` | 9685 |
| 24 bp | `12s_pimelodidae_ecoprimers24.csv` | 10132 |
| 25 bp | `12s_pimelodidae_ecoprimers25.csv` | 10430 |

## Notes

- The query notes say the 12S of complete mitogenomes was downloaded for some species, but the species were not recorded ("??").

## Update (November 2026)

- The original query had unquoted species names, so each name was searched as separate words and unrelated taxa were retrieved (*Silurus*, *Bothus pantherinus* and others; 52 of the 188 records). Running ecoPrimers on the original dataset reproduces the values above.
- The dataset was downloaded again with the species names quoted and the same marker and taxonomic terms as the other 12S queries (`AND 12S AND "chordates"[porgn:__txid7711] AND "ray-finned fishes"[porgn:__txid7898]`; see `config/queries/query_12s_pimelodidae.txt`): 130 records, 52 species. The 23 complete mitogenomes were reduced to the 12S region as annotated by NCBI (for the target, 69..1023 of ON408064 and its RefSeq copy NC_065247). No mRNA records, nuclear chromosomes or hybrids were returned, and every taxid is present in the taxonomy used, so the counterexample list is all 51 non-target species.
- *Steindachneridion amblyurum* is not in the dataset: its 3 records are annotated as "small subunit ribosomal RNA" and are not returned by the term "12S". It was left out to keep the query pattern of the other 12S designs.
- New ecoPrimers results (same parameters): 7573, 8195, 8642, 9089, 9685 and 10132 primer pairs for 20 to 25 bp. The output files produced in WSL and in an independent run are identical byte for byte.
- Output files: `results/12s_pimelodidae/12s_pimelodidae_ecoprimers20.csv` to `25.csv`.
