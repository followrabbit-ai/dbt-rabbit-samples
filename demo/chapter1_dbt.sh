#!/usr/bin/env bash
# Chapter 1 - dbt.  Paced demo driver: press Enter to advance each step.
#
# Before running:
#   1. cd into the dbt-rabbit-samples repo root
#   2. activate the dbt venv   (source dbt-rabbit/bin/activate)
#   3. source demo/00_env.sh
#   4. ./demo/chapter1_dbt.sh
#
# Record each block as its own take; clear_screen marks the cut points.
set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
# shellcheck source=demo/lib.sh
source demo/lib.sh

[ -n "${DEMO_ENV_SOURCED:-}" ] || { echo "Run:  source demo/00_env.sh   first"; exit 1; }
command -v dbt >/dev/null || { echo "dbt not on PATH - activate the venv first"; exit 1; }
guard_env GCP_PROJECT RABBIT_API_KEY RESERVATION_ID

clear_screen
# ==========================================================================
# BEAT A - the integration is a profile change plus three keys
# ==========================================================================
say "type: rabbitbigquery instead of bigquery. Three added keys. Same oauth."
run 'grep -nE "type:|rabbit_" profiles.sample.yml'
pause
say "And the models themselves - untouched. Plain dbt SQL."
run 'sed -n "1,20p" models/bikeshare/staging/stg_bikeshare_trips.sql'
pause
clear_screen

# ==========================================================================
# BEAT B - install & connect
# ==========================================================================
say "requirements.txt swaps dbt-bigquery for the Rabbit adapter."
run 'grep -nE "dbt-(rabbit-)?bigquery" requirements.txt'
run 'uv pip install -r requirements.txt | tail -n 3'
run 'export DBT_PROFILES_DIR="$(pwd)"; cp -f profiles.sample.yml profiles.yml'
run 'dbt debug'
pause
clear_screen

# ==========================================================================
# BEAT C - baseline: optimization OFF (no reservation)
# ==========================================================================
say "No reservation id -> Rabbit disables itself and dbt runs exactly as before."
run 'unset RABBIT_RESERVATION_IDS'
run 'dbt build --select bikeshare'
say "(wait for the build - cut this in the edit)"
run 'grep -n "Rabbit optimization" logs/dbt.log | tail -n 5'
pause
clear_screen

# ==========================================================================
# BEAT D - flip it ON (one reservation id, same command)
# ==========================================================================
say "One env var. Same dbt build. Watch the RabbitBigQuery lines appear."
run 'export RABBIT_RESERVATION_IDS="$RESERVATION_ID"'
run 'dbt build --select bikeshare --debug'
say "(wait for the build)"
run 'grep -nE "RabbitBigQuery" logs/dbt.log | tail -n 15'
pause
clear_screen

# ==========================================================================
# BEAT E - productionizing (optional, on camera only if you want it)
# ==========================================================================
say "Same adapter, containerised, key from Secret Manager, run as a Cloud Run Job."
run 'grep -nE "rabbitbigquery|set-secrets|rabbit" profiles.docker.yml .github/workflows/release.yml | head -n 12'
note "optional live run - uncomment to execute:"
note 'gcloud run jobs execute dbt-rabbit-samples --region=us-central1 --project="$GCP_PROJECT"'
echo
echo "== Chapter 1 script complete =="
