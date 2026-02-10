#!/bin/bash
set -eux

sleep 10

TIMEOUT=600

apt-get -o DPkg::Lock::Timeout=$TIMEOUT update -y
apt-get -o DPkg::Lock::Timeout=$TIMEOUT install -y docker.io

sudo apt install fontconfig openjdk-21-jre -y

sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list >/dev/null
sudo apt update
sudo apt install jenkins -y

systemctl enable jenkins
systemctl start jenkins
systemctl enable docker
systemctl start docker

usermod -aG docker jenkins

sleep 10

echo "Jenkins initial admin password: $(cat /var/lib/jenkins/secrets/initialAdminPassword)"
