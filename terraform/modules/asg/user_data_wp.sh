#!/bin/bash
set -eux

echo "Running apt commands with lock timeout..."

sleep 10
# Use 600 seconds (10 min) timeout – adjust if needed ( -1 = infinite, but risky)
TIMEOUT=600

apt-get -o DPkg::Lock::Timeout=$TIMEOUT update -y
apt-get -o DPkg::Lock::Timeout=$TIMEOUT install -y docker.io
# Wait for apt lock to be free (retry up to ~5 minutes)
systemctl enable docker
systemctl start docker

# Optional: give docker a moment to be ready
sleep 5

# Rest of your script...
docker rm -f wordpress || true

docker run -d --name wordpress \
  -p 80:80 \
  --restart always \
  -e WORDPRESS_DB_HOST=${db_host}:3306 \
  -e WORDPRESS_DB_USER=${db_user} \
  -e WORDPRESS_DB_PASSWORD=${db_pass} \
  -e WORDPRESS_DB_NAME=${db_name} \
  wordpress:latest
