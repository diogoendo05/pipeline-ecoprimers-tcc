#!/usr/bin/env bash
# ------------------------------------------------------------------
# Etapa 01 - Converte .gb para .fasta com obiconvert
# Uso: bash scripts/01_convert_genbank.sh <target_id>
# ------------------------------------------------------------------
set -euo pipefail
cd "$(dirname "$0")/.."

TARGET="${1:?informe o target_id, ex.: 12s_pimelodidae}"

# --- caminhos ---
ENTRADA=""
SAIDA=""

# --- verificacoes ---


# --- comando ---


