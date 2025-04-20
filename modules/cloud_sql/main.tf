# -------------------------------
# RESOURCE: Cloud SQL Instance (MySQL)
# -------------------------------
# Creates a basic MySQL 8.0 instance in the specified region
# GCP Docs: https://cloud.google.com/sql/docs/mysql/create-instance
resource "google_sql_database_instance" "default" {
  name             = var.db_instance_name
  database_version = "MYSQL_8_0"
  region           = var.region

  settings {
    tier = "db-f1-micro"  # Smallest tier (free eligible)
  }
}

# -------------------------------
# RESOURCE: SQL User
# -------------------------------
# Creates the database user to authenticate your app
# GCP Docs: https://cloud.google.com/sql/docs/mysql/create-manage-users
resource "google_sql_user" "users" {
  name     = var.db_user
  instance = google_sql_database_instance.default.name
  password = var.db_password
}

# -------------------------------
# RESOURCE: SQL Database
# -------------------------------
# Creates the database inside your Cloud SQL instance
# GCP Docs: https://cloud.google.com/sql/docs/mysql/create-manage-databases
resource "google_sql_database" "database" {
  name     = var.db_name
  instance = google_sql_database_instance.default.name
}