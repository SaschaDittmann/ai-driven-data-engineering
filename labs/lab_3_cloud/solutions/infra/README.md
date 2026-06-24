# Pokedex Platform Infrastructure

This directory contains Terraform configuration files to provision Google Cloud Platform (GCP) resources for the production deployment of the Pokedex competitive analytics platform.

## Resources Created

1. **BigQuery Datasets**:
   - `pokedex_raw` (stores raw API data loaded by `dlt`)
   - `pokedex_staging` (stores cleaned dbt staging views)
   - `pokedex_marts` (stores analytical dbt fact and dimension tables)
2. **Google Cloud Storage (GCS) Bucket**:
   - Staging bucket for `dlt` pipeline loading. Includes a lifecycle policy to automatically delete temporary files after 7 days.

## Prerequisites

- Terraform CLI installed.
- Access to a GCP project.
- Google Cloud SDK authenticated via:
  ```bash
  gcloud auth application-default login
  ```

## Usage

1. Copy the example variables file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```
2. Edit `terraform.tfvars` with your `project_id`, desired `region`, and a unique `bucket_name`.
3. Initialize and apply:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```
