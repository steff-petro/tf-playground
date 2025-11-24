terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.11.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_compute_project_metadata" "default" {
  metadata = {
    enable-oslogin = "TRUE"
  }
}
