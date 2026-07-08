FROM python:3.11-slim

WORKDIR /app

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

COPY requirements.txt .
RUN uv pip install --system -r requirements.txt

COPY dbt_project.yml ./
COPY profiles.docker.yml profiles.yml
COPY models/ models/
COPY macros/ macros/

ENV DBT_PROFILES_DIR=/app
ENV DBT_TARGET=prod

ENTRYPOINT ["dbt", "build", "--target", "prod", "--exclude", "resource_type:unit_test"]
