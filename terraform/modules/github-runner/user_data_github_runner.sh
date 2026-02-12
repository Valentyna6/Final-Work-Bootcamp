#!/bin/bash
set -eux

sleep 10

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

# Install Docker and AWS CLI (same as Jenkins)
apt_wait docker.io jq curl

systemctl enable docker
systemctl start docker

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# Create runner user
useradd -m -s /bin/bash runner
usermod -aG docker runner

# Download GitHub Actions runner
RUNNER_VERSION=$(curl -s https://api.github.com/repos/actions/runner/releases/latest | jq -r '.tag_name' | sed 's/v//')
mkdir -p /home/runner/actions-runner
cd /home/runner/actions-runner

curl -o actions-runner.tar.gz -L "https://github.com/actions/runner/releases/download/v$${RUNNER_VERSION}/actions-runner-linux-x64-$${RUNNER_VERSION}.tar.gz"
tar xzf actions-runner.tar.gz
rm actions-runner.tar.gz
chown -R runner:runner /home/runner/actions-runner

# Get registration token from GitHub PAT
echo "Requesting registration token for repo: ${github_repo}"
API_RESPONSE=$(curl -s -w "\nHTTP_CODE:%%{http_code}" -X POST \
  -H "Authorization: Bearer ${github_token}" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/${github_repo}/actions/runners/registration-token")

echo "GitHub API response: $API_RESPONSE"

REG_TOKEN=$(echo "$API_RESPONSE" | grep -v "HTTP_CODE" | jq -r '.token')
echo "Registration token: $REG_TOKEN"

if [ "$REG_TOKEN" = "null" ] || [ -z "$REG_TOKEN" ]; then
  echo "ERROR: Failed to get registration token. Check PAT permissions (needs Administration: Read and write)"
  exit 1
fi

# Configure runner (non-interactive)
su - runner -c "cd /home/runner/actions-runner && ./config.sh --url https://github.com/${github_repo} --token $REG_TOKEN --name ${runner_name} --unattended --replace"

# Install and start as systemd service
cd /home/runner/actions-runner
./svc.sh install runner
./svc.sh start

echo "GitHub Actions runner configured and started successfully"
