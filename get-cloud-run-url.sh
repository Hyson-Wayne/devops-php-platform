#!/bin/bash

# Script: get-cloud-run-url.sh
# Description: Retrieves the URL of a deployed Google Cloud Run service based on the environment.
# Usage: ./get-cloud-run-url.sh <environment>
# Example: ./get-cloud-run-url.sh dev

# ----------- Configuration ------------
PROJECT_ID="devops-php-platform"
REGION="us-central1"
LOG_FILE="cloud-run-url.log"

# ----------- Argument Check ------------
ENV="$1"

if [[ -z "$ENV" ]]; then
  echo "[ERROR] No environment specified. Usage: ./get-cloud-run-url.sh <environment>" | tee -a "$LOG_FILE"
  exit 1
fi

# Expected service naming: e.g., php-nginx-service-dev, php-nginx-service-prod, etc.
SERVICE_NAME="php-nginx-service"

echo "[INFO] Looking up Cloud Run service: $SERVICE_NAME" | tee -a "$LOG_FILE"

# ----------- Get Service URL ------------
URL=$(gcloud run services describe "$SERVICE_NAME" \
  --project="$PROJECT_ID" \
  --region="$REGION" \
  --format="value(status.url)" 2>>"$LOG_FILE")

# ----------- Error Handling ------------
if [[ $? -ne 0 || -z "$URL" ]]; then
  echo "[ERROR] Failed to retrieve URL for service '$SERVICE_NAME'. Check if the service exists or your permissions are correct." | tee -a "$LOG_FILE"
  exit 1
fi

# ----------- Output ------------
echo "[SUCCESS] Service URL for '$SERVICE_NAME': $URL" | tee -a "$LOG_FILE"