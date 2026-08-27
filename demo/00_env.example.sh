# Copy to demo/00_env.sh, fill in real values, then before recording:
#
#   source demo/00_env.sh
#
# demo/00_env.sh is gitignored. Never commit real keys or reservation IDs.
#
# This copy covers Chapter 1 (dbt). Chapter 2 (Airflow) lives in the
# rabbit-sample-dags repo and has its own demo/00_env.example.sh.

export DEMO_ENV_SOURCED=1

# --- GCP / BigQuery ---------------------------------------------------------
export GCP_PROJECT="your-project-id"
export GCP_DATASET="dbt_demo"
export GCP_LOCATION="US"

# BigQuery reservation, form:  project:location.reservation-name
export RESERVATION_ID="your-project:US.your-reservation"

# --- Rabbit ----------------------------------------------------------------
# Real key ONLY here (this file is gitignored). Never echo/cat it on camera.
export RABBIT_API_KEY="rabbit_xxxxxxxxxxxxxxxxxxxx"
export RABBIT_DEFAULT_PRICING_MODE="on_demand"
