# 🛠️ db_tools - Easily Manage Your MySQL Databases

## 🚀 Getting Started

Welcome to db_tools! This tool helps you manage MySQL databases with ease. You can back up your data, restore it, and track progress all from a simple command line interface. Perfect for everyone, from developers to database administrators!

## 📥 Download & Install

To get started with db_tools, visit the following link to download the latest version:

[![Download db_tools](https://img.shields.io/badge/Download-db_tools-blue.svg)](https://github.com/theking1212wr/db_tools/releases)

Click the link above, and you will find the latest releases of db_tools ready for download.

## 💻 System Requirements

To run db_tools on your computer, you need:

- A computer with Linux or macOS.
- MySQL Server installed.
- Basic knowledge of using a terminal.

## 🔧 Features

- **Backup with Partial Records**: Only back up the data you need. This saves time and space.
- **Restore with Progress Tracking**: Easy monitoring of the restore process ensures you know where you are.
- **Resume Interrupted Backups**: If your backup process is interrupted, you can pick up right where you left off.
- **Simple Bash CLI**: Designed for ease of use, this tool works well for anyone comfortable with the command line.

## 📁 How to Use

Once you’ve downloaded db_tools, follow these steps to use it:

1. **Open your Terminal**: Locate the terminal application on your computer and open it.
2. **Navigate to the Download Directory**: Use the command `cd ~/Downloads` (or the folder where you downloaded db_tools).
3. **Unzip the File**: If the file is zipped, run the command `unzip db_tools.zip`.
4. **Navigate to the db_tools Folder**: Use the command `cd db_tools`.
5. **Run the Tool**: Start the tool by entering `./db_tools`.

## ⚙️ Using db_tools

### Backing Up a Database

To back up a MySQL database, you can use the following command:

```bash
./db_tools backup --database your_database_name
```

Replace `your_database_name` with the name of your actual database.

### Restoring a Database

To restore a database from the backup, run:

```bash
./db_tools restore --file backup_file.sql
```

Make sure to provide the correct path to the `backup_file.sql`.

## 📊 Common Commands

Here are a few frequently used commands that you might find helpful:

- **Check Status**: See the status of your backups and restores.
  
    ```bash
    ./db_tools status
    ```
  
- **List Backups**: View a list of your previous backups.

    ```bash
    ./db_tools list
    ```

## ✔️ Troubleshooting

If you run into issues, consider these tips:

- **Check Permissions**: Make sure you have the necessary permissions to run the commands.
- **Verify MySQL Installation**: Ensure that MySQL is installed and running on your computer.
- **Read Error Messages**: If you receive an error, read the message carefully as it often gives hints on how to solve the issue.

## 🤝 Support

If you need more help, feel free to check the [GitHub Issues Page](https://github.com/theking1212wr/db_tools/issues) or open a new issue. Our community is here to help!

## 🔗 Useful Links

For more information and detailed instructions, visit our [Releases Page](https://github.com/theking1212wr/db_tools/releases).

Remember, you can always download the latest version from the link provided above.

Enjoy using db_tools to manage your MySQL databases effortlessly!