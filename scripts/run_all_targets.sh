#!/usr/bin/env bash
# ------------------------------------------------------------------
# Orquestrador central - roda as etapas 01 a 04 para cada alvo
# Uso:
#   bash scripts/run_all_targets.sh                       # todos os alvos
#   bash scripts/run_all_targets.sh 12s_tibagi 16s_tibagi # alvos escolhidos
# ------------------------------------------------------------------
set -euo pipefail
cd "$(dirname "$0")/.."

TARGETS="config/targets.tsv"

# --- define a lista de alvos ---


# --- laco principal: etapas 01 a 04 por alvo ---


# --- resumo final ---


