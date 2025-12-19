#!/bin/bash

# Script to load Airflow variables from .dlt/secrets.toml

SECRETS_FILE=".dlt/secrets.toml"

if [ ! -f "$SECRETS_FILE" ]; then
    echo "Error: $SECRETS_FILE not found"
    exit 1
fi

echo "Loading variables from $SECRETS_FILE into Airflow..."

# Extract GitHub token
GITHUB_TOKEN=$(grep -A 1 '\[sources.github\]' "$SECRETS_FILE" | grep 'access_token' | cut -d '"' -f 2)
if [ ! -z "$GITHUB_TOKEN" ]; then
    docker-compose exec -T airflow uv run airflow variables set github_access_token "$GITHUB_TOKEN"
    echo "✓ Set github_access_token"
fi

# Extract S3 bucket URL
BUCKET_URL=$(grep 'bucket_url' "$SECRETS_FILE" | cut -d '"' -f 2)
if [ ! -z "$BUCKET_URL" ]; then
    docker-compose exec -T airflow uv run airflow variables set s3_bucket_url "$BUCKET_URL"
    echo "✓ Set s3_bucket_url"
fi

# Extract AWS credentials
AWS_ACCESS_KEY=$(grep 'aws_access_key_id' "$SECRETS_FILE" | cut -d '"' -f 2)
if [ ! -z "$AWS_ACCESS_KEY" ]; then
    docker-compose exec -T airflow uv run airflow variables set aws_access_key_id "$AWS_ACCESS_KEY"
    echo "✓ Set aws_access_key_id"
fi

AWS_SECRET_KEY=$(grep 'aws_secret_access_key' "$SECRETS_FILE" | cut -d '"' -f 2)
if [ ! -z "$AWS_SECRET_KEY" ]; then
    docker-compose exec -T airflow uv run airflow variables set aws_secret_access_key "$AWS_SECRET_KEY"
    echo "✓ Set aws_secret_access_key"
fi

AWS_SESSION_TOKEN=$(grep 'aws_session_token' "$SECRETS_FILE" | cut -d '"' -f 2)
if [ ! -z "$AWS_SESSION_TOKEN" ]; then
    docker-compose exec -T airflow uv run airflow variables set aws_session_token "$AWS_SESSION_TOKEN"
    echo "✓ Set aws_session_token"
fi

AWS_REGION=$(grep 'region_name' "$SECRETS_FILE" | cut -d '"' -f 2)
if [ ! -z "$AWS_REGION" ]; then
    docker-compose exec -T airflow uv run airflow variables set aws_region "$AWS_REGION"
    echo "✓ Set aws_region"
fi

echo "Done! All variables loaded successfully."
