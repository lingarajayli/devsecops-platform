#!/usr/bin/env bash
set -euo pipefail

BUCKET_NAME="devsecops-artifact-platform"
ARTIFACT_NAME="build-artifact-$(date +%Y%m%d-%H%M%S).txt"

echo "Checking AWS identity..."
aws sts get-caller-identity

echo "Checking target bucket..."
aws s3 ls "s3://${BUCKET_NAME}" >/dev/null

echo "Creating artifact..."
cat > "${ARTIFACT_NAME}" <<EOF
Build artifact generated locally
Timestamp: $(date -Iseconds)
Bucket: ${BUCKET_NAME}
Platform: Floci
EOF

echo "Uploading artifact to S3..."
aws s3 cp "${ARTIFACT_NAME}" "s3://${BUCKET_NAME}/${ARTIFACT_NAME}"

echo "Verifying uploaded artifact..."
aws s3 ls "s3://${BUCKET_NAME}/${ARTIFACT_NAME}"

echo "Cleaning local artifact..."
rm -f "${ARTIFACT_NAME}"

echo "Artifact upload completed successfully."