#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
# This is a safety measure to ensure the script stops if any step fails.
set -e

# --- Application Lists ---

# Packages for personal deployment
personal_packages_apt=(
  "gnome-boxes"
  "docker.io"
  "docker-compose"
)

personal_packages_flatpak=(
  "org.telegram.desktop"
  "me.proton.Pass"
  "me.proton.Mail"
  "com.proton.www"
  "me.iepure.devtoolbox"
  "app.zen_browser.zen"
)

# Packages to be installed from the Debian APT repository
apt_packages=(
  # --- System & Development Tools ---
  "git"            # Version control system for tracking code changes.
  "curl"           # Command-line tool for transferring data with URLs.
  "telnet"         # A network protocol for remote command-line access.
  "openssh-server" # Allows secure remote connections to your machine via SSH.
  "golang-go"      # The Go programming language, needed for the security tools below.
  "neovim"         # A modern, highly extensible, Vim-based text editor.
  "tmux"           # Terminal multiplexer: lets you run multiple terminal sessions in one window.
  "wget"	   # Non-interactive netwrok downloader.
  "net-tools"	   # Pack of networking tools such as arp.
  "glow"	   # A good terminal md and code reader.
  "Firefox"  # Browser for crawling in zap.
  "Chromium" # Browser fro crawling in zap.

  # --- Desktop & GUI Applications ---
  "flatpak"                             # A system for building, distributing, and running sandboxed desktop apps.
  "gnome-software-plugin-flatpak"       # Integrates Flatpak apps into the GNOME Software center.
  "gnome-shell-extension-manager"       # A graphical tool to browse and manage GNOME Shell extensions.
  "gnome-shell-extension-blur-my-shell" # Adds a blur effect to the GNOME Shell (top panel, overview, etc.).
  "gnome-shell-extension-dashtodock"    # Transforms the GNOME dash into a configurable dock.
  "gnome-shell-extension-caffeine"      # Prevents the system from sleeping or showing the screensaver.
  "gnome-remote-desktop"                # Remote desktop buit-in in GNOME.

  # --- System Monitoring & Networking ---
  "btop"       # A modern, feature-rich resource monitor for the terminal.
  "fastfetch"  # A fast tool to display system information with a logo.
  "openresolv" # A framework for managing DNS information (resolv.conf).
  "nmap"       # Powerful network scanner for security auditing and discovery.
  "zenmap"     # A GUI for nmap if you need to see all the hosts and ports after scan.
  "openvpn"    # A robust and configurable VPN (Virtual Private Network) client/server.
  "wireguard"  # A modern, fast, and secure VPN protocol.

  # --- Security & CLI Tools ---
  "gh" # The official GitHub CLI, useful for interacting with code repositories.
  "jq" # A command-line JSON processor, essential for handling tool output.
  "wafw00f" # A cli tool to identify WAF of a web application.
  "proxychains4" # Tool for redirecting your connection throught a list of proxies.
  "recon-ng" # Powerfull framework for recon of your target.
  "aircrack-ng" # Wi-Fi security suite that let you intercept handshake and attack wpa2 hashes

  # --- Java Development ---
  "openjdk-21-jre" # Java Runtime Environment (runs Java apps).
  "openjdk-21-jdk" # Java Development Kit (builds Java apps).
  
  # --- Python packages ---
  "python3-setuptools" # Setup utilities for python3.
)
apt_custom_packages=(
  "zap" # The OWASP ZAP proxy for web app security testing (from a custom repo).
  "xpra" # The "Screen for X". Analog of tmux but for GUI application.
)
# GNOME Shell extension UUIDs to enable
gnome_extensions=(
  "blur-my-shell@aunetx"
  "dash-to-dock@micxgx.gmail.com"
  "caffeine@patapon.info"
)

# Go-based tools to install using 'go install'
go_tools=(
  "github.com/OWASP/Amass/v4/...@master"                          # In-depth attack surface mapping and asset discovery.
  "github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest" # A fast passive subdomain discovery tool.
  "github.com/projectdiscovery/katana/cmd/katana@latest"          # A next-generation crawling and spidering framework.
  "github.com/projectdiscovery/httpx/cmd/httpx@latest"            # A fast and multi-purpose HTTP toolkit.
  "github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest"       # Powerful vulnerability scanner based on templates.
  "github.com/gitleaks/gitleaks/v8@latest"                        # Scans git repositories for hardcoded secrets.
)

# --- Script Logic ---

# 1. Update package lists
echo "Updating package lists..."
sudo apt update

# 2. Install packages from APT
echo ""
echo ""
echo ""
echo ""
echo "Installing APT packages..."
sudo apt install -y "${apt_packages[@]}"

# 3. Fully upgrade the system
echo ""
echo ""
echo ""
echo ""
echo "Fully upgrading system..."
sudo apt full-upgrade -y

# Check for and run modernize-sources if it exists
echo ""
echo ""
echo ""
echo ""
if command -v apt modernize-sources &>/dev/null; then
  echo "Found 'apt modernize-sources'. Running it..."
  sudo apt modernize-sources -y
else
  echo "INFO: 'apt modernize-sources' command not found. Skipping."
fi

# 4. Add Custom APT Repository for ZAP (Modernized)
echo ""
echo ""
echo ""
echo ""
echo "Adding ZAP repository..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.opensuse.org/repositories/home:cabelo/Debian_Testing/Release.key | gpg --dearmor | sudo tee /etc/apt/keyrings/home_cabelo-debian_testing.gpg >/dev/null
echo "Types: deb
URIs: http://download.opensuse.org/repositories/home:/cabelo/Debian_Testing/
Suites: /
Components:
Signed-By: /etc/apt/keyrings/home_cabelo-debian_testing.gpg
" | sudo tee /etc/apt/sources.list.d/home:cabelo.sources

echo ""
echo ""
echo ""
echo ""
echo "Adding xpra repository..."
git clone https://github.com/Xpra-org/xpra
cd xpra
./setup.py install-repo
cd ..

# 5. Upgrading after adding custom repository
echo ""
echo ""
echo ""
echo ""
echo "updating once again..."
sudo apt update

# 6. Installing things from custom repository
echo ""
echo ""
echo ""
echo ""
echo "Installing custom packages..."
sudo apt install -y "${apt_custom_packages}"

# 7. Add Flathub repository
echo ""
echo ""
echo ""
echo ""
echo "Adding Flathub repository..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo >/dev/null

# 8. Install Go-based security tools
echo ""
echo ""
echo ""
echo ""
echo "Installing Go-based security tools..."
# The GOPATH will be set as the user who invoked sudo.
if command go install -v "${go_tools[@]}" &>/dev/null; then
  go install -v "${go_tools[@]}"
  else:
  echo "seems like go tools have been installed already. Skipping..."
fi

# 9. Add Go binary directory to the user's PATH in .profile
echo ""
echo ""
echo ""
echo ""
echo "Adding Go binary path to ~/.profile..."
# This ensures the tools are available in the terminal after the next login.
# We use sudo -u to run this as the user, not as root.
echo -e "\n# Add Go binaries to PATH\nexport PATH=\"\$HOME/go/bin:\$PATH\"" >>"$HOME/.profile"

# ==============================================
# ###                 NOTE                   ###
# ###  This part of code is not working due  ###
# ###  to nature of extensions installed     ###
# ###  via APT. This code should be moved    ###
# ###  to file and invoked with sudo somehow ###
# ###  Time To Think...                      ###
# ==============================================
# 10. Enable GNOME Shell Extensions
#echo "Enabling GNOME extensions..."
# This must run as the user, not root. $SUDO_USER refers to the user who ran sudo.
#for extension in "${gnome_extensions[@]}"; do
#  echo "Enabling $extension..."
#  gnome-extensions enable "$extension"
#done

# 11. Clean up
echo ""
echo ""
echo ""
echo ""
echo "Cleaning up unused packages..."
sudo apt autoremove -y

# 12. Updating and full-upgrading in case there's something unused
echo ""
echo ""
echo ""
echo ""
echo "Updating and full-upgrading once more"
sudo apt update && sudo apt full-upgrade -y
echo "--------------------------------------------------"
echo "✅ Setup complete!"
echo "--------------------------------------------------"

# 12. Ask user to reboot
read -p "A reboot is required for all changes to take effect. Reboot now? [Y/n] " -n 1 -r
echo # Move to a new line
if [[ $REPLY =~ ^[Yy]$ || $REPLY == "" ]]; then
  echo "Rebooting now..."
  sudo reboot
else
  echo "Please reboot your system later to apply all changes."
fi
