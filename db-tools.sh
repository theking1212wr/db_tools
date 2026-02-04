#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_FOLDER="$SCRIPT_DIR/scripts"

declare -A COMMAND_MAP
COMMAND_MAP["dump"]="db_dumper.sh:Dump a MySQL database"
COMMAND_MAP["restore"]="db_restore.sh:Restore a MySQL database from a SQL file"

get_available_commands() {
    local commands=()
    for script in "$SCRIPTS_FOLDER"/*.sh; do
        if [ -f "$script" ]; then
            basename "$script" .sh
        fi
    done
}

show_help() {
    echo "db-tools - MySQL database dump and restore utilities"
    echo ""
    echo "Usage: ./db-tools.sh <command> [options]"
    echo ""
    echo "Commands:"
    
    for cmd in "${!COMMAND_MAP[@]}"; do
        local info="${COMMAND_MAP[$cmd]}"
        local desc="${info#*:}"
        printf "  %-12s %s\n" "$cmd" "$desc"
    done
    
    echo ""
    echo "Run './db-tools.sh <command> --help' for more information on a command."
}

resolve_script() {
    local cmd="$1"
    
    if [[ -v COMMAND_MAP[$cmd] ]]; then
        local info="${COMMAND_MAP[$cmd]}"
        local script="${info%%:*}"
        echo "$SCRIPTS_FOLDER/$script"
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
    *)
        SCRIPT=$(resolve_script "$1")
        if [ $? -eq 0 ] && [ -x "$SCRIPT" ]; then
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
