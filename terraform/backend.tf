terraform {
  backend "gcs" {
    bucket  = "devops-php-platform-tfstate"
    prefix  = "terraform/state"
  }
}
