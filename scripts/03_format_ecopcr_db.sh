#!/usr/bin/env bash
# ------------------------------------------------------------------
# Etapa 03 - Gera o banco local com ecoPCRFormat.py
# Uso: bash scripts/03_format_ecopcr_db.sh <target_id>
# ------------------------------------------------------------------
set -euo pipefail
cd "$(dirname "$0")/.."

TARGET="${1:?informe o target_id, ex.: 12s_pimelodidae}"

# --- caminhos ---
GENBANK=""
TAXDUMP=""
PREFIXO=""

# --- verificacoes ---


# --- comando ---


