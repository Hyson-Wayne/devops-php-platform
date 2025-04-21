# DevOps PHP Platform

This project demonstrates the deployment of a containerized **PHP-FPM application** with **Nginx** to **Google Cloud Run** using **Terraform**, **Docker**, and **Google Cloud Platform (GCP)** services — all orchestrated as part of a technical DevOps test.

---

## Overview

- PHP application served via **Nginx** with **PHP-FPM**
- Deployed as a container to **Cloud Run**
- Infrastructure provisioned with **Terraform**
- Uses **Cloud SQL (MySQL)** and **Cloud Storage**
- Infrastructure state managed via **GCS remote backend**
- CI/CD automated with **GitHub Actions**
- Includes operational tooling via Bash script for live deployment lookup

---

## Architecture

```text
  +-------------+           +-------------------------+
  |  GitHub     |  CI/CD →  | Google Container Registry|
  +-------------+           +-------------------------+
                                 ↓
                          +----------------+
                          | Cloud Run (PHP)|
                          +----------------+
                                 ↓
        +-------------------+    ↓
        | Cloud SQL (MySQL) | ← Nginx + PHP-FPM
        +-------------------+    ↑
                                 ↓
                    +----------------------+
                    | Cloud Storage Bucket |
                    +----------------------+
```

---

## Technologies Used

| Tool/Service       | Role                                  |
|--------------------|---------------------------------------|
| **Terraform**       | Provision all GCP infrastructure     |
| **Google Cloud Run**| Host the containerized app           |
| **Cloud SQL**       | Host the MySQL database              |
| **Cloud Storage**   | Store static files                   |
| **Docker**          | Build and package the PHP app        |
| **GitHub Actions**  | CI/CD automation                     |
| **Bash Script**     | Retrieve service URL after deploy    |

---

## Project Structure

```
devops-php-platform/
├── app/                   # PHP entry point (index.php)
├── docker/                # Dockerfile and Nginx config
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── backend.tf
│   └── terraform.tfvars
├── modules/
│   └── cloud_sql/         # Reusable Terraform module for Cloud SQL
├── .github/workflows/     # GitHub Actions workflow
│   └── deploy.yml
├── get-cloud-run-url.sh   # Bash script to fetch Cloud Run service URL
├── .gitignore
└── README.md
```

---

## How to Deploy

### 1. Clone the repo

```bash
git clone https://github.com/Hyson-Wayne/devops-php-platform.git
cd devops-php-platform/terraform
```

### 2. Authenticate with GCP

```bash
gcloud auth login
gcloud auth application-default login
```

### 3. Set up Terraform backend

Ensure this bucket exists:

```bash
gsutil mb -p devops-php-platform -l us-central1 gs://devops-php-platform-tfstate
```

Then initialize:

```bash
terraform init
```

### 4. Apply Terraform configuration

```bash
terraform apply -var-file="terraform.tfvars"
```

---

## CI/CD Workflow with GitHub Actions

On each push to the `main` branch, the pipeline:

- Builds the Docker image
- Pushes it to GCR
- Deploys the image to Cloud Run

Secrets used:

| Secret Name       | Purpose                       |
|-------------------|-------------------------------|
| `GCP_PROJECT_ID`  | Your GCP project ID           |
| `GCP_REGION`      | Deployment region             |
| `GCP_SA_KEY`      | GCP service account credentials (JSON) |
| `IMAGE_NAME`      | Docker image name (e.g., php-nginx) |

---

## Live Cloud Run URL

Once deployed, Terraform will output a public Cloud Run URL.  
You can also use the script below to retrieve it on demand.

---

## Section 3: Retrieve Cloud Run Service URL (Bash Script)

A Bash script helps retrieve the live URL of your deployed Cloud Run service.

### Script: `get-cloud-run-url.sh`

**Location**: Root of this project

### How to Use

```bash
chmod +x get-cloud-run-url.sh
./get-cloud-run-url.sh dev
```

> Note: For this test, the service name is hardcoded to `php-nginx-service`.

### What It Does

- Describes the Cloud Run service via `gcloud run services describe`
- Logs the output to `cloud-run-url.log`

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Dockerfile not found | Specify `-f docker/Dockerfile` in `docker build` |
| php folder missing in image | Use `COPY ./app /var/www/html` instead |
| Docker push denied | Add `gcloud auth configure-docker` in workflow |
| Wrong service name in script | Update script to match deployed name |
| Push failed | Use `git pull --rebase` before pushing again |

---

## Potential Improvements

- Add PHP unit/integration tests and run them in CI
- Use Terraform Cloud for remote state management
- Add separate staging/production environments
- Automate HTTPS with a global load balancer
- Integrate Cloud Monitoring and Logging

---

## Author

**Hyson Wayne**  
DevOps | Cloud | Automation  
[LinkedIn](https://www.linkedin.com/in/nditafon-hyson-762a6623b/)
