locals {
  project_id = "sandbox-takai"
}

provider "google" {
  project = local.project_id
}

terraform {
  backend "gcs" {
    bucket = "sandbox-takai"
    prefix = "tfstate"
  }
  required_version = "~> 1.10.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.19.0"
    }
    time = {
      version = "~> 0.12.0"
    }
  }
}
