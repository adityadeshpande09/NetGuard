#!/usr/bin/env bash
# Installs the tools the dev container features don't cover.
set -euo pipefail

echo ">> apt packages"
sudo apt-get update -y
sudo apt-get install -y jq pipx openssh-client

echo ">> containerlab"
bash -c "$(curl -sL https://get.containerlab.dev)"

echo ">> k3d"
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

echo ">> trivy"
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh \
  | sudo sh -s -- -b /usr/local/bin

echo ">> ansible, ruff, uv (via pipx)"
pipx ensurepath
pipx install --include-deps ansible
pipx install ruff
pipx install uv

echo ">> Claude Code (native installer)"
curl -fsSL https://claude.ai/install.sh | bash

echo ">> done. Open a new terminal, run 'claude', and log in."
