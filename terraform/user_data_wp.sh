#!/bin/bash
set -eux

sudo apt-get update -y
sudo apt-get install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker

sudo docker rm -f wordpress || true

sudo docker run -d --name wordpress \
  -p 80:80 \
  --restart always \
  -e WORDPRESS_DB_HOST=${db_host}:3306 \
  -e WORDPRESS_DB_USER=${db_user} \
  -e WORDPRESS_DB_PASSWORD=${db_pass} \
  -e WORDPRESS_DB_NAME=${db_name} \
  wordpress:latest
