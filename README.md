# db-tools

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Bash](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![MySQL](https://img.shields.io/badge/Database-MySQL-orange.svg)](https://www.mysql.com/)
[![Maintenance](https://img.shields.io/badge/Maintained-yes-brightgreen.svg)](https://github.com/the-perfect-developer/db_tools/commits/main)

Bash scripts for dumping and restoring MySQL databases with progress tracking and resume support.

## Features

- **Partial dumps**: Fetch only the latest N records from large tables
- **Full table dumps**: Specify tables that need complete data
- **Resume support**: Interrupted dumps can be resumed from where they left off
- **Progress display**: Visual progress bar using `pv`
- **Collation compatibility**: Automatically converts MySQL 8.0+ collations for older versions

## Requirements

- `mysql` and `mysqldump` clients
- `pv` (pipe viewer) for progress display
- `sed` for collation conversion

Install dependencies:

```bash
# Debian/Ubuntu
sudo apt install mysql-client pv

# macOS
brew install mysql-client pv
```

## Installation

### Option 1: Run directly

Clone the repository and run commands directly:

```bash
git clone https://github.com/the-perfect-developer/db_tools.git
cd db_tools
./dbtools.sh --help
```

### Option 2: Install to PATH

Install to `/usr/local/bin` for system-wide access:

```bash
git clone https://github.com/the-perfect-developer/db_tools.git
cd db_tools
sudo ./install.sh --install
```

Now you can run `dbtools` from anywhere:

```bash
dbtools --help
dbtools dump -u root -d mydb
```

To uninstall:

```bash
sudo ./install.sh --uninstall
```

## Usage

Use the unified `dbtools.sh` command:

```bash
./dbtools.sh <command> [options]

Commands:
  dump      Dump a MySQL database
  restore   Restore a MySQL database from a SQL file
```

**Examples:**

```bash
# Dump a database
./dbtools.sh dump -u root -d mydb

# Restore a database
./dbtools.sh restore -u root -d mydb -f backup.sql

# Get help
./dbtools.sh --help
./dbtools.sh dump --help
```

## Commands

### dump

Dump a MySQL database with optional table filtering.

```bash
./dbtools.sh dump [OPTIONS]
```

**Options:**

| Option | Description | Default |
|--------|-------------|---------|
| `-u, --user` | Database username | (required) |
| `-p, --password` | Database password | (optional) |
| `-h, --host` | Database host | localhost |
| `-P, --port` | Database port | 3306 |
| `-d, --database` | Database name | (required) |
| `-o, --output` | Output SQL file | `<database>.sql` |
| `-l, --limit` | Max records per table for non-full tables | 500 |
| `-t, --tables` | Comma-separated list of tables to dump fully | (none) |
| `--help` | Show help message | |

**Examples:**

```bash
# Basic dump with default 500 record limit
./dbtools.sh dump -u root -d mydb

# Dump with custom record limit
./dbtools.sh dump -u root -d mydb --limit=1000

# Dump with specific tables to be dumped fully
./dbtools.sh dump -u root -d mydb -t users,orders,products

# Full example with all options
./dbtools.sh dump -u root -p secret -h 192.168.1.100 -P 3306 -d mydb -o backup.sql -l 2000 -t users,orders
```

### restore

Restore a MySQL database from a SQL file.

```bash
./dbtools.sh restore [OPTIONS]
```

**Options:**

| Option | Description | Default |
|--------|-------------|---------|
| `-u, --user` | Database username | (required) |
| `-p, --password` | Database password | (optional) |
| `-h, --host` | Database host | localhost |
| `-P, --port` | Database port | 3306 |
| `-d, --database` | Database name | (required) |
| `-f, --file` | SQL file to restore | (required) |
| `--help` | Show help message | |

**Examples:**

```bash
# Basic restore
./dbtools.sh restore -u root -d mydb -f backup.sql

# Restore to remote server
./dbtools.sh restore -u root -p secret -h 192.168.1.100 -P 3306 -d mydb -f backup.sql
```

## How It Works

### Dumping

1. Fetches list of all tables in the database
2. For each table:
   - If in `--tables` list: dumps complete table with all data
   - Otherwise: dumps table structure + latest N records (based on `--limit`)
3. Progress is tracked in a `.progress` file for resume support
4. If interrupted, rerun the same command to resume

### Restoring

1. Creates the database if it doesn't exist
2. Converts MySQL 8.0+ collations to compatible ones for older versions
3. Imports the SQL file with progress display

## Author

**Dilan D Chandrajith** - [The Perfect Developer](https://github.com/the-perfect-developer)

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.
