resource "google_bigquery_dataset" "raw" {
  dataset_id                  = "${var.dataset_prefix}_raw"
  friendly_name               = "Pokedex Raw Dataset"
  description                 = "Houses raw tables ingested directly from PokeAPI"
  location                    = var.region
  default_table_expiration_ms = null

  labels = {
    env = "prod"
  }
}

resource "google_bigquery_dataset" "staging" {
  dataset_id                  = "${var.dataset_prefix}_staging"
  friendly_name               = "Pokedex Staging Dataset"
  description                 = "Cleaned and prepared staging tables"
  location                    = var.region
  default_table_expiration_ms = null

  labels = {
    env = "prod"
  }
}

resource "google_bigquery_dataset" "marts" {
  dataset_id                  = "${var.dataset_prefix}_marts"
  friendly_name               = "Pokedex Marts Dataset"
  description                 = "Analytical and business marts tables"
  location                    = var.region
  default_table_expiration_ms = null

  labels = {
    env = "prod"
  }
}
