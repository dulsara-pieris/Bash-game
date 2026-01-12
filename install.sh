#!/usr/bin/env bash

printf "\033[36m"  # COLOR_CYAN
cat << "EOF"

  ███████╗████████╗ █████╗ ██████╗     ██████╗ ██╗   ██╗███╗   ██╗███╗   ██╗███████╗██████╗ 
  ██╔════╝╚══██╔══╝██╔══██╗██╔══██╗    ██╔══██╗██║   ██║████╗  ██║████╗  ██║██╔════╝██╔══██╗
  ███████╗   ██║   ███████║██████╔╝    ██████╔╝██║   ██║██╔██╗ ██║██╔██╗ ██║█████╗  ██████╔╝
  ╚════██║   ██║   ██╔══██║██╔══██╗    ██╔══██╗██║   ██║██║╚██╗██║██║╚██╗██║██╔══╝  ██╔══██╗
  ███████║   ██║   ██║  ██║██║  ██║    ██║  ██║╚██████╔╝██║ ╚████║██║ ╚████║███████╗██║  ██║
  ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝    ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝

EOF

set -e

echo "Installing Star Runner…"

# Remove old install
sudo rm -f /usr/local/bin/star-runner
sudo rm -rf /usr/local/share/Star-runner

# Create install dir
sudo mkdir -p /usr/local/share/Star-runner
cd /usr/local/share/
git clone https://github.com/dulsara-pieris/Star-runner
cd Star-runner

# Create launcher to run Python main.py
sudo tee /usr/local/bin/star-runner > /dev/null << 'EOF'
#!/usr/bin/env bash
# Launch Python Star Runner
exec python3 /usr/local/share/Star-runner/src/main.py "$@"
EOF

sudo chmod +x /usr/local/bin/star-runner

# Make sure profile exists
touch ~/.star_runner_profile.json

# Give user ownership
chown $USER:$USER ~/.star_runner_profile.json

# Set read/write permissions for user only
chmod 600 ~/.star_runner_profile.json

echo "✔ Star Runner installed!"
echo "You can now run the game with: star-runner"
