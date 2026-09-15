# pipeline-ecoprimers-tcc

<!-- descricao do projeto em uma ou duas frases -->


## Objetivo

<!-- o que o pipeline entrega e em que contexto do TCC -->


## Alvos

<!-- os parametros de cada alvo ficam em config/targets.tsv -->

| target_id | marker | grupo / area | root_taxid | min_len | max_len |
|-----------|--------|--------------|------------|---------|---------|
| 12s_pimelodidae | 12S | | | | |
| 16s_pimelodidae | 16S | | | | |
| 12s_bryconidae | 12S | | | | |
| 16s_bryconidae | 16S | | | | |
| 12s_tibagi | 12S | | | | |
| 16s_tibagi | 16S | | | | |
| 12s_iguacu | 12S | | | | |
| 16s_iguacu | 16S | | | | |


## Estrutura

```
config/targets.tsv        metadados de cada alvo
config/queries/           busca booleana do GenBank por alvo
data/taxdump/             names.dmp e nodes.dmp (compartilhado)
data/raw/                 arquivos .gb exportados do NCBI
data/processed/<alvo>/    fasta, taxids e banco ecoPCR
scripts/                  etapas 01-04 + orquestrador
results/<alvo>/           CSVs com primers candidatos
```


## Pre-requisitos

<!-- ferramentas e versoes, criacao do ambiente, obtencao do taxdump -->


## Como rodar

<!-- comandos de execucao, por alvo e para todos -->


## Parametros

<!-- o que cada coluna de targets.tsv significa e como escolher os valores -->


## Referencias

<!-- artigos, manuais, links -->
