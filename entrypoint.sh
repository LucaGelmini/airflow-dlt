#!/bin/bash
set -e

# Wait for Airflow to be ready
echo "Waiting for Airflow to initialize..."
sleep 5

# Load variables from secrets.toml if it exists
SECRETS_FILE="/app/.dlt/secrets.toml"

if [ -f "$SECRETS_FILE" ]; then
    echo "Loading Airflow variables from $SECRETS_FILE..."

    # Extract and set variables
    GITHUB_TOKEN=$(grep -A 1 '\[sources.github\]' "$SECRETS_FILE" | grep 'access_token' | cut -d '"' -f 2)
    [ ! -z "$GITHUB_TOKEN" ] && uv run airflow variables set github_access_token "$GITHUB_TOKEN" 2>/dev/null && echo "✓ Set github_access_token"

    BUCKET_URL=$(grep 'bucket_url' "$SECRETS_FILE" | cut -d '"' -f 2)
    [ ! -z "$BUCKET_URL" ] && uv run airflow variables set s3_bucket_url "$BUCKET_URL" 2>/dev/null && echo "✓ Set s3_bucket_url"

    AWS_ACCESS_KEY=$(grep 'aws_access_key_id' "$SECRETS_FILE" | cut -d '"' -f 2)
    [ ! -z "$AWS_ACCESS_KEY" ] && uv run airflow variables set aws_access_key_id "$AWS_ACCESS_KEY" 2>/dev/null && echo "✓ Set aws_access_key_id"

    AWS_SECRET_KEY=$(grep 'aws_secret_access_key' "$SECRETS_FILE" | cut -d '"' -f 2)
    [ ! -z "$AWS_SECRET_KEY" ] && uv run airflow variables set aws_secret_access_key "$AWS_SECRET_KEY" 2>/dev/null && echo "✓ Set aws_secret_access_key"

    AWS_SESSION_TOKEN=$(grep 'aws_session_token' "$SECRETS_FILE" | cut -d '"' -f 2)
    [ ! -z "$AWS_SESSION_TOKEN" ] && uv run airflow variables set aws_session_token "$AWS_SESSION_TOKEN" 2>/dev/null && echo "✓ Set aws_session_token"

    AWS_REGION=$(grep 'region_name' "$SECRETS_FILE" | cut -d '"' -f 2)
    [ ! -z "$AWS_REGION" ] && uv run airflow variables set aws_region "$AWS_REGION" 2>/dev/null && echo "✓ Set aws_region"

    echo "Variables loaded successfully!"
else
    echo "Warning: $SECRETS_FILE not found. Skipping variable loading."
fi

# Start Airflow standalone
echo "Starting Airflow standalone..."
exec uv run airflow standalone
