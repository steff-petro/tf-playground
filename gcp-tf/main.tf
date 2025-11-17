terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.11.0"
    }
  }
}

provider "google" {
  project = "affable-ring-478314-u4"
  region  = "us-central1"
  zone    = "us-central1-a"
}
