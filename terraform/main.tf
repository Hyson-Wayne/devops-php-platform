# -------------------------------
# MODULE: Cloud SQL (MySQL)
# -------------------------------
# Creates a MySQL Cloud SQL instance using a reusable module
# GCP Docs: https://cloud.google.com/sql/docs/mysql
module "cloud_sql" {
  source           = "../modules/cloud_sql"
  db_instance_name = var.db_instance_name
  db_user          = var.db_user
  db_password      = var.db_password
  db_name          = var.db_name
  region           = var.region
}

# -------------------------------
# RESOURCE: Cloud Storage Bucket
# -------------------------------
# Used for storing static assets like images, JS, CSS, etc.
# GCP Docs: https://cloud.google.com/storage/docs/creating-buckets
resource "google_storage_bucket" "static_files" {
  name          = var.bucket_name
  location      = var.region
  force_destroy = true  # Automatically deletes contents when bucket is deleted
}

# -------------------------------
# RESOURCE: Cloud Run Service
# -------------------------------
# Deploys a containerized PHP-FPM app to a serverless Cloud Run service
# GCP Docs: https://cloud.google.com/run/docs/deploying
resource "google_cloud_run_service" "php_app" {
  name     = "php-nginx-service"
  location = var.region

  template {
    spec {
      containers {
        image = "gcr.io/${var.project_id}/php-nginx:latest"  # Docker image deployed earlier

        ports {
          container_port = 8080  # Required by Cloud Run
        }

        resources {
          limits = {
            memory = "512Mi"
            cpu    = "1"
          }
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale" = "1"
        "autoscaling.knative.dev/maxScale" = "2"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# -------------------------------
# RESOURCE: IAM Binding for Public Access
# -------------------------------
# Allows unauthenticated (public) users to access the Cloud Run service
# GCP Docs: https://cloud.google.com/run/docs/authenticating/public
resource "google_cloud_run_service_iam_member" "public_access" {
  service  = google_cloud_run_service.php_app.name
  location = var.region
  role     = "roles/run.invoker"
  member   = "allUsers"
}