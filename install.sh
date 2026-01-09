#!/usr/bin/env bash
set -e

APP="star-runner"
TMP="$(mktemp -d)"

echo "Downloading $APP release..."
curl -sSL "https://github.com/dulsara-pieris/Bash-game/releases/download/v1.0.0/star-runner-1.0.0.tar.gz" | tar -xz -C "$TMP"

echo "Installing..."
sudo bash "$TMP/Bash-game/install.sh"

echo "Cleaning up..."
rm -rf "$TMP"

echo "✔ Done! Run the game with: $APP"
