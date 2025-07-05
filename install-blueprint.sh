#!/bin/bash

# Exit on error
set -e

echo "[+] Updating and installing required dependencies..."
sudo apt update && sudo apt install -y curl wget unzip git zip ca-certificates gnupg

echo "[+] Installing Node.js 20..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo apt update && sudo apt install -y nodejs

echo "[+] Installing Yarn globally..."
npm i -g yarn

echo "[+] Navigating to Pterodactyl directory and installing Node dependencies..."
cd /var/www/pterodactyl
yarn

echo "[+] Downloading latest Blueprint release..."
wget "$(curl -s https://api.github.com/repos/BlueprintFramework/framework/releases/latest | grep 'browser_download_url' | cut -d '"' -f 4)" -O release.zip

echo "[+] Extracting Blueprint release..."
unzip -o release.zip

echo "[+] Creating .blueprintrc configuration file..."
cat <<EOF > /var/www/pterodactyl/.blueprintrc
WEBUSER="www-data";
OWNERSHIP="www-data:www-data";
USERSHELL="/bin/bash";
EOF

echo "[+] Setting execute permissions and running blueprint.sh..."
chmod +x blueprint.sh
bash blueprint.sh

echo "[✓] Blueprint installation complete! 🎉"
