resource "google_storage_bucket" "dlt_staging" {
  name          = var.bucket_name
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true

  lifecycle_rule {
    condition {
      age = 7 # Automatically delete staging files after 7 days
    }
    action {
      type = "Delete"
    }
  }

  labels = {
    env = "prod"
  }
}
