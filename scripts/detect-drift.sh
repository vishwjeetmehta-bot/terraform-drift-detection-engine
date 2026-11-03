#!/usr/bin/env bash
# ==============================================================================
# Enterprise Terraform State Drift Detector
# Author: Vishwjeet Kumar Mehta
# Exit codes:
#   0 = Succeeded, no drift detected
#   1 = Terraform execution error
#   2 = Drift detected (Infrastructure out of sync)
# ==============================================================================
set -eo pipefail

TARGET_DIR="${1:-.}"
echo "==> Running Drift Check against: $TARGET_DIR"

cd "$TARGET_DIR"
terraform init -input=false

echo "==> Running detailed plan check..."
set +e
terraform plan -detailed-exitcode -no-color -out=drift.tfplan > drift_summary.log 2>&1
EXIT_CODE=$?
set -e

if [ $EXIT_CODE -eq 0 ]; then
  echo "✅ No infrastructure drift detected. Live state is aligned with Git IaC."
  exit 0
elif [ $EXIT_CODE -eq 2 ]; then
  echo "⚠️ Infrastructure drift detected! Live state differs from code."
  cat drift_summary.log
  python3 $(dirname "$0")/notify-teams.py drift_summary.log
  exit 2
else
  echo "❌ Terraform plan command failed with error code $EXIT_CODE."
  cat drift_summary.log
  exit 1
fi
