#!/bin/bash
# Remote installer for dbtools
# Usage: curl -fsSL https://raw.githubusercontent.com/the-perfect-developer/db_tools/main/get.sh | sudo bash

set -e

REPO_URL="https://github.com/the-perfect-developer/db_tools.git"
INSTALL_DIR="/opt/dbtools"
BIN_DIR="/usr/local/bin"

echo "Installing dbtools..."

# Check for git
if ! command -v git &> /dev/null; then
    echo "Error: git is required but not installed"
    exit 1
fi

# Remove existing installation
if [ -d "$INSTALL_DIR" ]; then
    echo "Removing existing installation..."
    rm -rf "$INSTALL_DIR"
fi

# Clone repository
echo "Cloning repository..."
git clone --depth 1 "$REPO_URL" "$INSTALL_DIR" > /dev/null 2>&1

# Make scripts executable
chmod +x "$INSTALL_DIR/dbtools.sh"
chmod +x "$INSTALL_DIR/scripts/"*.sh

# Create symlink
ln -sf "$INSTALL_DIR/dbtools.sh" "$BIN_DIR/dbtools"

echo ""
echo "dbtools installed successfully!"
echo ""
echo "Usage:"
echo "  dbtools --help"
echo "  dbtools dump -u root -d mydb"
echo "  dbtools restore -u root -d mydb -f backup.sql"
echo ""
echo "To uninstall:"
echo "  sudo rm -rf $INSTALL_DIR $BIN_DIR/dbtools"
