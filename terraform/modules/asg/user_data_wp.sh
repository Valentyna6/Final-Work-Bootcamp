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

apt_wait docker.io awscli

# Wait for apt lock to be free (retry up to ~5 minutes)
systemctl enable docker
systemctl start docker

# Optional: give docker a moment to be ready
sleep 5

aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin ${ecr_repository_url}

docker pull ${ecr_repository_url}:latest
# Rest of your script...
docker rm -f wordpress || true

#   This is  ecr repo ${ecr_repository_url}

docker run -d --name wordpress \
  -p 80:80 \
  --restart always \
  -e WORDPRESS_DB_HOST=${db_host}:3306 \
  -e WORDPRESS_DB_USER=${db_user} \
  -e WORDPRESS_DB_PASSWORD=${db_pass} \
  -e WORDPRESS_DB_NAME=${db_name} \
  ${ecr_repository_url}:latest

echo "INITIALIZATION SCRIPT FINISHED"
