# Debian Trixie - Application Security Workstation Setup
An automated setup script to provision a Debian 'Trixie' system for Application Security, Penetration Testing, and CTF environments.

## Overview
This script provides a comprehensive and opinionated setup for a security-focused workstation. It automates the installation and configuration of a curated toolkit, saving significant time in environment preparation.
Designed with flexibility in mind, it supports both headless server deployments (for remote GUI access via Xpra) and full local workstations with the GNOME Desktop Environment.

`Please keep in mind that by default there's no git or curl in fresh Debian Trixie`

---
### Key Features:

* Automated Provisioning: Sets up a full security toolkit with a single command.
* Flexible Deployment: Suitable for both headless servers and graphical workstations
* Remote Access Ready: Pre-configured for efficient remote GUI application access using Xpra and RDP.
* Curated Toolset: Includes a selection of industry-standard and powerful open-source tools for security professionals.

### Core Toolkit:

* Checkmarx ZAP: A powerful, open-source dynamic application security testing (DAST) tool. A preferred alternative to enterprise-only solutions.
* Xpra: A persistent remote display server ("screen for X11") that allows individual GUI applications to be accessed over low-bandwidth or unstable network connections.
* tmux: An essential terminal multiplexer for creating and managing persistent command-line sessions.
* nmap: The industry-standard network exploration tool and security/port scanner.
* wafw00f: An efficient tool for identifying and fingerprinting Web Application Firewalls (WAF).

### Usage
Two methods are provided for installation. The git clone method is recommended for security and transparency.

### Recommended Method: Git Clone
Cloning the repository allows you to review the script's contents before execution.
```
# Clone the repository
git clone https://github.com/J0hn-C77n/trixie-bb-postinstall.git

# Navigate into the project directory
cd trixie-bb-postinstall

# Make the script executable
chmod u+x setup.sh

# Execute the script with root privileges
sudo ./setup.sh
```

### Alternative Method: Direct Download
For rapid deployment on disposable systems, you may download and run the script directly.
```
# Download the installation script
wget https://github.com/J0hn-C77n/trixie-bb-postinstall/raw/main/setup.sh

# Make the script executable
chmod u+x setup.sh

# Execute the script with root privileges
sudo ./setup.sh
```

Disclaimer
This script performs system-level changes and is provided "as-is" without warranty. Please review the contents of the script to understand its functionality before running it. Use at your own risk.
