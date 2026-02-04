#!/bin/bash
# @description Update dbtools to the latest version
# @category System

INSTALL_DIR="/opt/dbtools"
REPO_URL="https://github.com/the-perfect-developer/db_tools.git"

show_help() {
    echo "Update dbtools to the latest version"
    echo ""
    echo "Usage: dbtools update [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --help    Show this help message"
    echo ""
    echo "This command pulls the latest changes from the repository."
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Check if running from installed location
if [ -d "$INSTALL_DIR/.git" ]; then
    echo "Updating dbtools..."
    cd "$INSTALL_DIR"
    
    # Fetch and pull latest changes
    git fetch origin main --quiet
    
    LOCAL=$(git rev-parse HEAD)
    REMOTE=$(git rev-parse origin/main)
    
    if [ "$LOCAL" = "$REMOTE" ]; then
        echo "Already up to date!"
        exit 0
    fi
    
    git pull origin main --quiet
    
    # Make scripts executable
    chmod +x "$INSTALL_DIR/dbtools.sh"
    chmod +x "$INSTALL_DIR/scripts/"*.sh
    
    echo "Updated successfully!"
    echo ""
    git log --oneline -5
else
    # Running from local clone, try to update there
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    
    if [ -d "$SCRIPT_DIR/.git" ]; then
        echo "Updating dbtools..."
        cd "$SCRIPT_DIR"
        
        git fetch origin main --quiet
        
        LOCAL=$(git rev-parse HEAD)
        REMOTE=$(git rev-parse origin/main)
        
        if [ "$LOCAL" = "$REMOTE" ]; then
            echo "Already up to date!"
            exit 0
        fi
        
        git pull origin main --quiet
        
        echo "Updated successfully!"
        echo ""
        git log --oneline -5
    else
        echo "Error: Cannot find git repository"
        echo ""
        echo "If you installed via curl, reinstall with:"
        echo "  curl -fsSL https://raw.githubusercontent.com/the-perfect-developer/db_tools/main/get.sh | sudo bash"
        exit 1
    fi
fi
