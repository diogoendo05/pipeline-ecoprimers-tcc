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

Value recorded in the workflow notes for each ecoPrimers run (original dataset, now replaced; see the update below).

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

## Update (November 2026)

- In the original dataset the target species (ON408064 and NC_065247) entered as its complete mitochondrial genome (16,527 bp), so ecoPrimers designed primers on the whole mitogenome and not only on 16S; that explains the ~135,000 pairs above. The `.gb` in the repository (12 records) was also not the file the FASTA (212 records) came from.
- The dataset was downloaded again with the same species list, with the query punctuation fixed (11 curly quotes and 2 names without the opening quote), and curated (see `config/queries/query_16s_iguacu.txt`): 306 complete mitogenomes reduced to the NCBI-annotated 16S region (target: 1096..2276), nuclear mRNA records and chromosomes removed. Final file: 929 records.
- The two taxids excluded in the original run (1550064, 2590590) are *Misgurnus* hybrids. The same rule was applied to the 16 hybrid taxa of the new dataset. Taxid 3738817 (*Garcialebias araucarianus*, MH594620) was also excluded: it is newer than the taxonomy dump used, so `ecoPCRFormat.py` drops the record and ecoPrimers crashed (segmentation fault) when it was in the `-i` list.
- New ecoPrimers results (`-l 150 -L 300 -r 1000982`, 85 counterexample taxids, 68 counterexample species with the NCBI taxonomy): 92936, 97011, 100116, 103252, 106217 and 109125 primer pairs for 20 to 25 bp. The output files produced in WSL and in an independent run are identical (MD5).

## Redone on 12 November 2026

All 8 designs were downloaded again on the same day, with the same query pattern and curation rules (see the README, "Data curation"), and ecoPrimers was run again with the same parameters.

- Dataset: 889 records, 103 taxa. Same download as the version redone on 9-10 November; 40 records of other markers removed (32 *Clarias gariepinus* "small subunit" records, 7 cytochrome b and 1 D-loop record). Exclusions unchanged: 16 hybrid taxa and taxid 3738817. See `config/queries/query_16s_iguacu.txt`.
- Counterexample taxids (`-i`): 85.
- ecoPrimers pairs, 20 to 25 bp: 92403, 96628, 99782, 102884, 105746, 108653.
- Pairs with dif 3 = 0 and class GG (in silico PCR): 151, 169, 200, 233, 231, 225.
- A second, independent run of the whole procedure produced the same output files byte for byte (WSL check pending).
