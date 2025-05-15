## File Management Bash Scripting

### Overview

This project is a suite of Bash scripts designed to automate and manage file system operations efficiently. These tools cover a variety of file and folder tasks such as sorting, renaming, deduplication, backups, encryption, synchronization, and space analysis.

All scripts are designed to be:

- Lightweight and POSIX-compliant (where possible)

- Easy to run via command line

- Safe for use on local file systems

### List of Scripts

1. file_sorter.sh – Automatic File Sorter
   Organizes files in a target directory into subfolders based on file types.

Key Features:

- Detects file types via extensions

- Automatically creates folders (Documents, Images, Videos, etc.)

- Moves files into appropriate folders

Usage:

```bash
./file_sorter.sh /directory_path

```

2. file_renamer.sh – Batch File Renamer
   Renames multiple files in bulk using user-defined naming rules.

Key Features:

- Add prefixes, suffixes, counters, or dates

- Supports custom patterns (regex)

- Ensures unique filenames

Usage:

```bash
./batch_rename.sh /path/to/files prefix="img_" suffix="_2025" use_counter=true

```

3. duplicates_finder.sh – Duplicate File Finder
   Finds and optionally removes or moves duplicate files based on size and content hashing.

Key Features:

- Compares files by size and checksum (MD5/SHA256)

- Offers interactive choice: delete or move duplicates

- Logs actions for auditing

Usage:

```bash

./find_duplicates.sh /path/

```

4. backup_files.sh – File Backup Tool
   Creates compressed or uncompressed backups of important files or directories.

Key Features:

- Full or partial backups

- Optional gzip compression

- Timestamped backups

- Scheduling via cron supported

Usage:

```bash

./backup_tool.sh /path_to_source /path_to_backup [--compress]

```

5. analyze_disk_space.sh – Disk Usage Visualizer
   Displays a tree-structured report of disk usage for directories and files.

Key Features:

- Recursively scans directories

- Displays usage in human-readable format

- Allows sorting by size

- Filters out small/irrelevant files

Usage:

```bash

./disk_usage_analyzer.sh /path_to_analyze [--min-size=10M] [--sort=desc]

```

6. encryption.sh – File Encryption & Decryption Tool
   Encrypts or decrypts files using a secure password-based method (OpenSSL).

Key Features:

- AES-256 encryption

- Secure password handling

- Works with any file type

- Prevents overwriting original files

Usage:

```bash

# Encrypt a file
./encrypt_decrypt.sh encrypt /file_path/

# Decrypt a file
./encrypt_decrypt.sh decrypt /file_path/

```

7. sync_files.sh – Two-Way Folder Synchronizer
   Keeps two directories in sync with conflict resolution and logging.

Key Features:

- Two-way synchronization

- Compares timestamps to resolve changes

- Logs every change

- Handles nested subfolders

Usage:

```bash

./folder_sync.sh /path_folder1 /path_folder2

```

### Installation

- Clone this repository:

```bash

git clone https://github.com/Makuo67/Db-and-Bash_Lab/Db-and-Bash_Lab/BashScripting-FileManagement.git

cd BashScripting-FileManagement

```

- Make scripts executable:

```bash

chmod +x *.sh

```

- Run the desired script as described above.

### Requirements

- Bash (version 4 or higher recommended)

- Standard Unix/Linux utilities:

find, cp, mv, du, awk, sort, md5sum or sha256sum, openssl, etc.

Optional: cron (for scheduling backups)

### Testing

Tested on:

- Ubuntu 22.04 LTS
