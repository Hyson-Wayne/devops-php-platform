
# DevOps PHP Platform 

This project demonstrates the deployment of a containerized **PHP-FPM application** with **Nginx** to **Google Cloud Run** using **Terraform**, **Docker**, and **Google Cloud Platform (GCP)** services — all orchestrated as part of a technical DevOps test.

---

## Overview

- PHP application served via **Nginx** with **PHP-FPM**
- Deployed as a container to **Cloud Run**
- Infrastructure provisioned with **Terraform**
- Uses **Cloud SQL (MySQL)** and **Cloud Storage**
- Infrastructure state managed via **GCS remote backend**
- All code, configuration, and setup documented

---

##  Architecture

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

##  Technologies Used

| Tool/Service       | Role                                  |
|--------------------|---------------------------------------|
| **Terraform**       | Provision all GCP infrastructure     |
| **Google Cloud Run**| Host the containerized app           |
| **Cloud SQL**       | Host the MySQL database              |
| **Cloud Storage**   | Store static files                   |
| **Docker**          | Build and package the PHP app        |
| **GitHub**          | Code and version control             |

---

##  Project Structure

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
└── README.md
```

---

##  How to Deploy

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

### 3. Set up Terraform backend (already configured)

Ensure this bucket exists:
```bash
gsutil mb -p devops-php-platform -l us-central1 gs://devops-php-platform-tfstate
```

Then:
```bash
terraform init
```

### 4. Deploy infrastructure

```bash
terraform apply -var-file="terraform.tfvars"
```

---

##  Live Cloud Run URL

Once deployed, Terraform will output a public Cloud Run URL. Open it in your browser to verify your app is running.

---


---

## Section 3: Retrieve Cloud Run Service URL (Bash Script)

As part of this project’s automation and operational tooling, a simple Bash script is included to help retrieve the **public URL of a deployed Cloud Run service** based on the environment.

### Script: `get-cloud-run-url.sh`

**Location**: Root of this project (`./get-cloud-run-url.sh`)

### Purpose

Quickly fetch the deployed URL of your Cloud Run service so you can:
- Verify deployments
- Integrate with frontends or external tools
- Debug environments

### How to Use

```bash
chmod +x get-cloud-run-url.sh
./get-cloud-run-url.sh dev
```

> Note: For this test, the service name is hardcoded to `php-nginx-service`. You can extend this for other environments.

### Example Output

```
[INFO] Looking up Cloud Run service: php-nginx-service
[SUCCESS] Service URL for 'php-nginx-service': https://php-nginx-service-abcde-uc.a.run.app
```

### What It Does

- Accepts an optional environment argument (e.g., `dev`, `prod`)
- Looks up a matching Cloud Run service
- Uses `gcloud run services describe` to extract the public URL
- Logs all actions and errors into `cloud-run-url.log`

### Output Log

Each run creates/appends a log file:
```bash
cloud-run-url.log
```

Add it to `.gitignore` to avoid versioning logs.

---

## Final Note

This script demonstrates your ability to support real-world operations with simple automation, which is critical for DevOps reliability and observability.



## References

- [Cloud SQL Docs](https://cloud.google.com/sql/docs/mysql)
- [Cloud Run Docs](https://cloud.google.com/run/docs)
- [Terraform GCP Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)

---

## ‍ Author

**Hyson Wayne**  
https://www.linkedin.com/in/nditafon-hyson-762a6623b/
