#!/bin/bash

show_help() {
    echo "Usage: db-tools dump [OPTIONS]"
    echo ""
    echo "Dump a MySQL database with optional table filtering."
    echo ""
    echo "Options:"
    echo "  -u, --user <username>     Database username (required)"
    echo "  -p, --password <password> Database password (optional)"
    echo "  -h, --host <host>         Database host (default: localhost)"
    echo "  -P, --port <port>         Database port (default: 3306)"
    echo "  -d, --database <name>     Database name (required)"
    echo "  -o, --output <file>       Output SQL file (default: <database>.sql)"
    echo "  -l, --limit <number>      Max records per table for non-full tables (default: 500)"
    echo "  -t, --tables <list>       Comma-separated list of tables to dump fully"
    echo "  --help                    Show this help message"
    echo ""
    echo "Example:"
    echo "  db-tools dump -u root -p secret -h localhost -P 3306 -d mydb"
    echo "  db-tools dump --user=root --database=mydb --limit=1000"
    echo "  db-tools dump -u root -d mydb -t users,orders,products"
}

DB_USER=""
DB_PASS=""
DB_HOST="localhost"
DB_PORT="3306"
DB_NAME=""
DUMP_FILE=""
RECORD_LIMIT="500"
FULL_TABLES=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -u|--user)
            DB_USER="$2"
            shift 2
            ;;
        --user=*)
            DB_USER="${1#*=}"
            shift
            ;;
        -p|--password)
            if [ -n "$2" ] && [[ ! "$2" =~ ^- ]]; then
                DB_PASS="$2"
                shift 2
            else
                shift
            fi
            ;;
        --password=*)
            DB_PASS="${1#*=}"
            shift
            ;;
        -h|--host)
            DB_HOST="$2"
            shift 2
            ;;
        --host=*)
            DB_HOST="${1#*=}"
            shift
            ;;
        -P|--port)
            DB_PORT="$2"
            shift 2
            ;;
        --port=*)
            DB_PORT="${1#*=}"
            shift
            ;;
        -d|--database)
            DB_NAME="$2"
            shift 2
            ;;
        --database=*)
            DB_NAME="${1#*=}"
            shift
            ;;
        -o|--output)
            DUMP_FILE="$2"
            shift 2
            ;;
        --output=*)
            DUMP_FILE="${1#*=}"
            shift
            ;;
        -l|--limit)
            RECORD_LIMIT="$2"
            shift 2
            ;;
        --limit=*)
            RECORD_LIMIT="${1#*=}"
            shift
            ;;
        -t|--tables)
            FULL_TABLES="$2"
            shift 2
            ;;
        --tables=*)
            FULL_TABLES="${1#*=}"
            shift
            ;;
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

if [ -z "$DB_USER" ] || [ -z "$DB_NAME" ]; then
    echo "Error: --user and --database are required"
    echo ""
    show_help
    exit 1
fi

if [ -z "$DUMP_FILE" ]; then
    DUMP_FILE="${DB_NAME}.sql"
fi

PROGRESS_FILE="${DB_NAME}.progress"

IFS=',' read -ra SELECTED_TABLES <<< "$FULL_TABLES"

MYSQL_OPTS="-u $DB_USER -h $DB_HOST -P $DB_PORT"
if [ -n "$DB_PASS" ] && [ "$DB_PASS" != "" ]; then
    MYSQL_OPTS="$MYSQL_OPTS -p$DB_PASS"
fi

is_selected_table() {
    local table="$1"
    for selected in "${SELECTED_TABLES[@]}"; do
        if [[ "$selected" == "$table" ]]; then
            return 0
        fi
    done
    return 1
}

is_table_done() {
    local table="$1"
    if [ -f "$PROGRESS_FILE" ]; then
        grep -qx "$table" "$PROGRESS_FILE"
        return $?
    fi
    return 1
}

mark_table_done() {
    echo "$1" >> "$PROGRESS_FILE"
}

mkdir -p "$(dirname "$DUMP_FILE")"

if [ -f "$PROGRESS_FILE" ]; then
    DONE_COUNT=$(wc -l < "$PROGRESS_FILE")
    echo "Resuming previous dump. $DONE_COUNT tables already completed."
    echo ""
else
    > "$DUMP_FILE"
fi

TABLES=($(mysql $MYSQL_OPTS -N -e \
  "SELECT table_name FROM information_schema.tables WHERE table_schema='$DB_NAME';"))

TOTAL_TABLES=${#TABLES[@]}
CURRENT=0

echo "Found $TOTAL_TABLES tables to dump"
echo ""

for t in "${TABLES[@]}"; do
    ((CURRENT++))

    if is_table_done "$t"; then
        echo "[$CURRENT/$TOTAL_TABLES] Skipping (already done): $t"
        continue
    fi

    if is_selected_table "$t"; then
        echo "[$CURRENT/$TOTAL_TABLES] Dumping table (full): $t"
        
        if mysqldump $MYSQL_OPTS $DB_NAME $t \
            --single-transaction \
            --quick \
            --routines \
            --triggers \
            --events \
            --no-tablespaces \
            2>/dev/null | pv -N "$t" >> "$DUMP_FILE"; then
            mark_table_done "$t"
        else
            echo "Error dumping $t. Restart script to resume."
            exit 1
        fi
    else
        echo "[$CURRENT/$TOTAL_TABLES] Dumping table (latest $RECORD_LIMIT): $t"
        
        if ! mysqldump $MYSQL_OPTS $DB_NAME $t \
            --single-transaction \
            --no-data \
            --no-tablespaces \
            2>/dev/null >> "$DUMP_FILE"; then
            echo "Error dumping $t structure. Restart script to resume."
            exit 1
        fi
        
        if mysqldump $MYSQL_OPTS $DB_NAME $t \
            --single-transaction \
            --no-create-info \
            --no-tablespaces \
            --where="1=1 ORDER BY 1 DESC LIMIT $RECORD_LIMIT" \
            2>/dev/null | pv -N "$t" >> "$DUMP_FILE"; then
            mark_table_done "$t"
        else
            echo "Error dumping $t data. Restart script to resume."
            exit 1
        fi
    fi

done

rm -f "$PROGRESS_FILE"

echo ""
echo "Dump complete! File: $DUMP_FILE"
echo "Total size: $(du -h "$DUMP_FILE" | cut -f1)"
