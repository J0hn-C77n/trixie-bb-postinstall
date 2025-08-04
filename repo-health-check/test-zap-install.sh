#!/bin/bash
#
# This script tests the installation of the ZAP package from various
# Debian and Ubuntu repositories provided by the OpenSUSE Build Service.
# It sequentially adds each repository, attempts to install ZAP,
# reports the result, and cleans up before proceeding to the next.
# The script is designed to continue even if an installation fails.
#

# Exit immediately if a command returns a non-zero status.
set -e

# --- Reusable function to test a repository ---
# Arguments:
#   $1: A descriptive name for the repository (e.g., "Debian 12").
#   $2: The URL fragment for the specific repository on the OBS server.
test_repo() {
    local repo_name="$1"
    local repo_url_fragment="$2"
    local base_obs_url="http://download.opensuse.org/repositories/home:/cabelo"

    local repo_url="${base_obs_url}/${repo_url_fragment}/"
    local key_url="${repo_url}Release.key"
    local list_file="/etc/apt/sources.list.d/zap-test-repo.list"
    local gpg_file="/etc/apt/trusted.gpg.d/zap-test-repo.gpg"

    echo ""
    echo "========================================================"
    echo "### Testing ZAP installation from: ${repo_name}"
    echo "========================================================"

    # --- Setup ---
    echo ">>> Configuring repository: ${repo_url}"
    echo "deb [arch=amd64] ${repo_url} /" > "${list_file}"
    curl -fsSL "${key_url}" | gpg --dearmor > "${gpg_file}"

    # --- Update and Install ---
    echo ">>> Updating package cache..."
    # Add flags to ignore potential GPG key expiration warnings
    apt-get update -o Acquire::AllowInsecureRepositories=true -o Acquire::AllowDowngradeToInsecureRepositories=true

    echo ">>> Attempting to install 'zap' package..."
    if ! apt-get install -y zap; then
        echo "--- INFO: 'apt-get install zap' failed. This can be due to repository issues or dependency conflicts."
    else
        echo "--- INFO: 'apt-get install zap' succeeded."
    fi

    # --- Report and Cleanup ---
    echo ">>> Reporting package status with 'apt-cache policy zap':"
    apt-cache policy zap
    echo ""

    echo ">>> Cleaning up for next test..."
    # Use '|| true' to prevent script exit if the package was not installed
    apt-get remove -y zap || true
    apt-get autoremove -y --purge
    rm -f "${list_file}" "${gpg_file}"
    apt-get clean
}

# --- Main Execution ---
# The script starts here by calling the test function for each target repository.

test_repo "Debian 12 (Bookworm)" "Debian_12"
test_repo "Debian Testing" "Debian_Testing"
test_repo "Debian Unstable (Sid)" "Debian_Unstable"
test_repo "Ubuntu 24.04 (Noble Numbat)" "xUbuntu_24.04"
test_repo "Ubuntu 23.10 (Mantic Minotaur)" "xUbuntu_23.10"
test_repo "Ubuntu 22.04 (Jammy Jellyfish)" "xUbuntu_22.04"

echo ""
echo "========================================================"
echo "### All repository tests are complete."
echo "========================================================"
