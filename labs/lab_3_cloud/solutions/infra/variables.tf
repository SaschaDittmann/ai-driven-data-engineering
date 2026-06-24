variable "project_id" {
  description = "The Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "The Google Cloud region to provision resources in"
  type        = string
  default     = "us-central1"
}

variable "dataset_prefix" {
  description = "Prefix for the BigQuery datasets"
  type        = string
  default     = "pokedex"
}

variable "bucket_name" {
  description = "The name of the GCS bucket for dlt pipeline staging"
  type        = string
}
