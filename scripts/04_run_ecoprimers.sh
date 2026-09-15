#!/usr/bin/env bash
# ------------------------------------------------------------------
# Etapa 04 - Roda o ecoPrimers (20 a 25 pb)
# Uso: bash scripts/04_run_ecoprimers.sh <target_id>
# ------------------------------------------------------------------
set -euo pipefail
cd "$(dirname "$0")/.."

TARGET="${1:?informe o target_id, ex.: 12s_pimelodidae}"

# --- parametros lidos de config/targets.tsv ---
ROOT_TAXID=""
MIN_LEN=""
MAX_LEN=""

# --- parametros do ecoPrimers ---
ERROS=""
QUORUM=""
COMPRIMENTOS=()

# --- caminhos ---
BANCO=""
SAIDA_DIR=""

# --- verificacoes ---


# --- laco de execucao ---


