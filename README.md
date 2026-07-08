# dbt-rabbit-samples

Sample [dbt](https://www.getdbt.com/) project that mirrors the BigQuery ELT pipelines in [rabbit-sample-dags](https://github.com/followrabbit-ai/rabbit-sample-dags) using dbt models instead of Airflow DAGs.

Two independent pipelines run against BigQuery public datasets:

| Pipeline | Source | Staging | Mart |
| --- | --- | --- | --- |
| **Bikeshare** | `bigquery-public-data.austin_bikeshare.bikeshare_trips` | `stg_bikeshare_trips` | `mart_daily_rides` |
| **Bitcoin Cash** | `bigquery-public-data.crypto_bitcoin_cash.transactions` | `stg_bch_transactions` | `mart_daily_bch_transactions` |

Each pipeline loads a rolling 30-day window into staging, then aggregates to a daily mart. The Airflow demos also export marts to GCS as Parquet — that step is intentionally omitted here and can be added as orchestration after `dbt run`.

## Prerequisites

1. **Python 3.10+**
2. **Google Cloud project** with BigQuery enabled
3. **Authentication** — run once:
   ```bash
   gcloud auth application-default login
   ```
4. **BigQuery IAM** on your project:
   - `roles/bigquery.jobUser` (project level)
   - `roles/bigquery.dataEditor` on the target dataset
5. **Public data access** — `roles/bigquery.dataViewer` on `bigquery-public-data` is granted by default.

Create the base dataset (dbt creates `dbt_demo_staging` and `dbt_demo_marts` automatically on first run):

```bash
export GCP_PROJECT=your-project-id
bq --location=US mk --dataset "${GCP_PROJECT}:dbt_demo"
```

## Setup

### 1. Virtual environment

**pip:**

```bash
python3 -m venv dbt-rabbit
source dbt-rabbit/bin/activate
pip install -r requirements.txt
```

**uv:**

```bash
uv venv dbt-rabbit
source dbt-rabbit/bin/activate
uv pip install -r requirements.txt
```

### 2. Profile

Copy the sample profile and set your project:

```bash
mkdir -p ~/.dbt
cp profiles.sample.yml ~/.dbt/profiles.yml
```

Or point dbt at the repo for local testing:

```bash
export DBT_PROFILES_DIR="$(pwd)"
cp profiles.sample.yml profiles.yml
```

Set environment variables:

```bash
export GCP_PROJECT=your-project-id
export GCP_DATASET=dbt_demo      # optional, this is the default
export GCP_LOCATION=US           # optional, this is the default
```

### 3. Verify connection

```bash
dbt debug
```

## Running models

Run both pipelines:

```bash
dbt run
```

Run a single pipeline:

```bash
dbt run --select bikeshare
dbt run --select bitcoin_cash
```

Run tests:

```bash
dbt test
```

## Project layout

```
models/
├── bikeshare/
│   ├── staging/stg_bikeshare_trips.sql
│   └── marts/mart_daily_rides.sql
└── bitcoin_cash/
    ├── staging/stg_bch_transactions.sql
    └── marts/mart_daily_bch_transactions.sql
```

Models land in BigQuery under schema suffixes:

- `{project}.dbt_demo_staging` — staging tables
- `{project}.dbt_demo_marts` — mart tables

## Roadmap

1. **Phase 1 (current)** — Generic dbt project with standard `dbt-bigquery` adapter
2. **Phase 2** — Rabbit Pricing Model Optimization via [`dbt-rabbit-bigquery`](https://github.com/followrabbit-ai/bq-job-optimizer-dbt)
3. **Phase 3** — CI/CD and GCP deployment
4. **Phase 4** — GCS Parquet export (post-`dbt run` orchestration)

## License

MIT — see [LICENSE](LICENSE).
