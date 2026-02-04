#!/bin/bash
# @description Install dbtools to system PATH

INSTALL_DIR="/usr/local/bin"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXECUTABLE="dbtools"

show_help() {
    echo "Install dbtools to system PATH"
    echo ""
    echo "Usage: ./install.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --install     Install dbtools (creates symlink in $INSTALL_DIR)"
    echo "  --uninstall   Remove dbtools from $INSTALL_DIR"
    echo "  --help        Show this help message"
    echo ""
    echo "After installation, you can run 'dbtools' from anywhere:"
    echo "  dbtools dump -u root -d mydb"
    echo "  dbtools restore -u root -d mydb -f backup.sql"
}

install() {
    if [ ! -f "$SCRIPT_DIR/dbtools.sh" ]; then
        echo "Error: dbtools.sh not found in $SCRIPT_DIR"
        exit 1
    fi

    # Check if we have write permission
    if [ ! -w "$INSTALL_DIR" ]; then
        echo "Error: No write permission to $INSTALL_DIR"
        echo "Run with sudo: sudo ./install.sh --install"
        exit 1
    fi

    # Remove existing symlink if present
    if [ -L "$INSTALL_DIR/$EXECUTABLE" ]; then
        rm "$INSTALL_DIR/$EXECUTABLE"
    fi

    # Create symlink
    ln -s "$SCRIPT_DIR/dbtools.sh" "$INSTALL_DIR/$EXECUTABLE"
    
    if [ $? -eq 0 ]; then
        echo "Installed successfully!"
        echo "You can now run 'dbtools' from anywhere."
        echo ""
        echo "Try: dbtools --help"
    else
        echo "Error: Failed to create symlink"
        exit 1
    fi
}

uninstall() {
    if [ ! -L "$INSTALL_DIR/$EXECUTABLE" ]; then
        echo "dbtools is not installed in $INSTALL_DIR"
        exit 1
    fi

    # Check if we have write permission
    if [ ! -w "$INSTALL_DIR" ]; then
        echo "Error: No write permission to $INSTALL_DIR"
        echo "Run with sudo: sudo ./install.sh --uninstall"
        exit 1
    fi

    rm "$INSTALL_DIR/$EXECUTABLE"
    
    if [ $? -eq 0 ]; then
        echo "Uninstalled successfully!"
    else
        echo "Error: Failed to remove symlink"
        exit 1
    fi
}

# Main
case "$1" in
    --install)
        install
        ;;
    --uninstall)
        uninstall
        ;;
    --help|"")
        show_help
        ;;
    *)
        echo "Unknown option: $1"
        show_help
        exit 1
        ;;
esac
