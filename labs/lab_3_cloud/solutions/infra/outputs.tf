output "project_id" {
  description = "The Google Cloud Project ID"
  value       = var.project_id
}

output "region" {
  description = "The GCP region"
  value       = var.region
}

output "dlt_staging_bucket_name" {
  description = "The name of the GCS bucket for dlt staging"
  value       = google_storage_bucket.dlt_staging.name
}

output "dlt_staging_bucket_url" {
  description = "The URL of the GCS bucket for dlt staging"
  value       = google_storage_bucket.dlt_staging.url
}

output "raw_dataset_id" {
  description = "The ID of the raw BigQuery dataset"
  value       = google_bigquery_dataset.raw.dataset_id
}

output "staging_dataset_id" {
  description = "The ID of the staging BigQuery dataset"
  value       = google_bigquery_dataset.staging.dataset_id
}

output "marts_dataset_id" {
  description = "The ID of the marts BigQuery dataset"
  value       = google_bigquery_dataset.marts.dataset_id
}
