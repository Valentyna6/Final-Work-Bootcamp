#!/bin/bash
set -eux

echo "!!!RUNNING!!! INITIALIZATION SCRIPT"

apt_wait() {
  local max=30
  local wait=10

  for ((i = 1; i <= $${max}; i++)); do
    echo "Attempt $${i}/$${max} ..."

    if apt-get update -y && apt-get install -y "$@"; then
      echo "Success: install $@"
      return 0
    fi

    echo "Failed → sleeping $${wait}"
    sleep "$${wait}"
  done

  echo "ERROR: apt still failing after $${max} attempts" >&2
  return 1
}

apt_wait docker.io jq unzip

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# Wait for apt lock to be free (retry up to ~5 minutes)
systemctl enable docker
systemctl start docker

# Optional: give docker a moment to be ready
sleep 5

aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin ${ecr_repository_url}

docker pull ${ecr_repository_url}:stable
# Rest of your script...
docker rm -f wordpress || true

# Fetch DB credentials from AWS Secrets Manager
SECRET_JSON=$(aws secretsmanager get-secret-value \
  --secret-id "${secret_arn}" \
  --region eu-west-1 \
  --query SecretString \
  --output text)

DB_USER=$(echo "$SECRET_JSON" | jq -r '.db_user')
DB_PASS=$(echo "$SECRET_JSON" | jq -r '.db_pass')
DB_NAME=$(echo "$SECRET_JSON" | jq -r '.db_name')

docker run -d --name wordpress \
  -p 80:80 \
  --restart always \
  -e WORDPRESS_DB_HOST=${db_host}:3306 \
  -e WORDPRESS_DB_USER="$DB_USER" \
  -e WORDPRESS_DB_PASSWORD="$DB_PASS" \
  -e WORDPRESS_DB_NAME="$DB_NAME" \
  ${ecr_repository_url}:stable

echo "INITIALIZATION SCRIPT FINISHED"
