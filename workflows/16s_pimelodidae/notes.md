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

Value recorded in the workflow notes for each ecoPrimers run (original dataset, now replaced; see the update below).

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

## Update (November 2026)

- The original dataset was built from the 12S search: all 184 records were returned by the 12S query and only 82 by the 16S one; only the target species entered with its 16S region (1096..2276 of ON408064). Running ecoPrimers on that dataset reproduces the values above exactly.
- The dataset was downloaded again with the 16S query and the species names quoted (111 records, 52 species, only Pimelodidae genera). The 23 complete mitogenomes were reduced to the 16S region as annotated by NCBI. For the target species (ON408064 and its RefSeq copy NC_065247) the annotation covers 1096..2276 (1181 bp), although the gene extends to the tRNA-Leu at 2777; the NCBI annotation was kept, as in the original analysis.
- New ecoPrimers results (same parameters): 14818, 16763, 18058, 19338, 20603 and 21852 primer pairs for 20 to 25 bp. The output files produced in WSL and in an independent run are identical byte for byte.
- ecoPCR check of six 21-bp pairs (serial numbers 7090, 7091, 7130, 7131, 7140, 7141; `-k -e 3 -l 50 -L 300`): all six amplify the target with no mismatch, and also *Steindachneridion scriptum* and *Megalonema amaxanthum* with 1 mismatch, *Sorubimichthys planiceps* and *Leiarius pictus* with 2. The results in WSL and in the independent run are identical.

## Redone on 12 November 2026

All 8 designs were downloaded again on the same day, with the same query pattern and curation rules (see the README, "Data curation"), and ecoPrimers was run again with the same parameters.

- Dataset: 111 records, 52 taxa; identical, byte for byte, to the version redone on 2-3 November. See `config/queries/query_16s_pimelodidae.txt`.
- Counterexample taxids (`-i`): 51.
- ecoPrimers pairs, 20 to 25 bp: 14818, 16763, 18058, 19338, 20603, 21852.
- Pairs with dif 3 = 0 and class GG (in silico PCR): 1, 0, 0, 0, 0, 0.
- A second, independent run of the whole procedure produced the same output files byte for byte (WSL check pending).
