#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_FOLDER="$SCRIPT_DIR/scripts"
VERSION="1.0.0"

# Colors
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
DIM='\033[2m'
BOLD='\033[1m'
NC='\033[0m' # No Color

show_banner() {
    echo -e "${CYAN}"
    cat << 'EOF'
     _ _     _              _     
  __| | |__ | |_ ___   ___ | |___ 
 / _` | '_ \| __/ _ \ / _ \| / __|
| (_| | |_) | || (_) | (_) | \__ \
 \__,_|_.__/ \__\___/ \___/|_|___/
EOF
    echo -e "${NC}"
    echo -e "${DIM}MySQL Database Utilities${NC} ${YELLOW}v${VERSION}${NC}"
    echo ""
}

get_script_description() {
    local script="$1"
    grep -m1 "^# @description" "$script" 2>/dev/null | sed 's/^# @description //'
}

get_script_category() {
    local script="$1"
    local category=$(grep -m1 "^# @category" "$script" 2>/dev/null | sed 's/^# @category //')
    echo "${category:-Other}"
}

show_help() {
    show_banner
    
    echo -e "${BOLD}Usage:${NC} dbtools <command> [options]"
    echo ""
    
    # Collect scripts by category
    declare -A categories
    declare -A scripts_in_category
    
    for script in "$SCRIPTS_FOLDER"/*.sh; do
        if [ -f "$script" ] && [ -x "$script" ]; then
            local cmd=$(basename "$script" .sh)
            local desc=$(get_script_description "$script")
            local category=$(get_script_category "$script")
            [ -z "$desc" ] && desc="No description available"
            
            # Add category to list if new
            if [ -z "${categories[$category]}" ]; then
                categories[$category]=1
            fi
            
            # Append script to category
            scripts_in_category[$category]+="$cmd|$desc"$'\n'
        fi
    done
    
    # Define category order (Database first, System last)
    local category_order=("Database" "System" "Other")
    
    for category in "${category_order[@]}"; do
        if [ -n "${scripts_in_category[$category]}" ]; then
            echo -e "${GREEN}${category} Commands:${NC}"
            while IFS='|' read -r cmd desc; do
                [ -z "$cmd" ] && continue
                printf "  ${BOLD}%-12s${NC} %s\n" "$cmd" "$desc"
            done <<< "${scripts_in_category[$category]}"
            echo ""
        fi
    done
    
    echo -e "${DIM}Run 'dbtools <command> --help' for more information.${NC}"
}

resolve_script() {
    local cmd="$1"
    local script="$SCRIPTS_FOLDER/${cmd}.sh"
    
    if [ -f "$script" ] && [ -x "$script" ]; then
        echo "$script"
        return 0
    fi
    
    return 1
}

if [ $# -eq 0 ]; then
    show_help
    exit 1
fi

case "$1" in
    --help|-h|help)
        show_help
        exit 0
        ;;
    --version|-v)
        echo "dbtools v${VERSION}"
        exit 0
        ;;
    *)
        SCRIPT=$(resolve_script "$1")
        if [ $? -eq 0 ]; then
            shift
            "$SCRIPT" "$@"
        else
            echo "Unknown command: $1"
            echo ""
            show_help
            exit 1
        fi
        ;;
esac
