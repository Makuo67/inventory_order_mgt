#!/bin/bash

# ============================
# File Backup Utility
# ============================
# This script allows full or partial backups of important files to a target directory.
# Features:
# - Full backup: all files in the source directory
# - Partial backup: only files modified in the last N days
# - Compression: backups are saved as .tar.gz archives
# - Timestamping: backup files are named with the current date
# - Scheduling: can be added to cron for regular execution
#
# Usage:
# ./backup_files.sh [source_dir] [backup_dir] [mode: full|partial] [days] [compress: yes|no]
#
# Example (full backup, with compression):
# ./backup_files.sh /home/user/documents /mnt/backup full 0 yes
#
# Example (partial backup from last 3 days, no compression):
# ./backup_files.sh /home/user/projects /mnt/backup partial 3 no
#
# ============================

# ----------------------------
# Input validation
# ----------------------------
if [[ $# -lt 5 ]]; then
    echo "Usage: $0 [source_dir] [backup_dir] [full|partial] [days] [yes|no]"
    exit 1
fi

SOURCE_DIR="$1"
BACKUP_DIR="$2"
MODE="$3"
DAYS="$4"
COMPRESS="$5"

DATE_STR=$(date +"%Y-%m-%d_%H-%M-%S")
ARCHIVE_NAME="backup_${DATE_STR}"

# ----------------------------
# Check if source and backup directories exist
# ----------------------------
if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Error: Source directory '$SOURCE_DIR' does not exist."
    exit 1
fi

mkdir -p "$BACKUP_DIR"

# ----------------------------
# Create a temporary working directory
# ----------------------------
TMP_DIR=$(mktemp -d)

# ----------------------------
# Copy files based on backup mode
# ----------------------------
if [[ "$MODE" == "full" ]]; then
    echo "Performing full backup..."
    cp -a "$SOURCE_DIR"/. "$TMP_DIR"/
elif [[ "$MODE" == "partial" ]]; then
    echo "Performing partial backup: Files modified in last $DAYS day(s)..."
    find "$SOURCE_DIR" -type f -mtime -"$DAYS" -exec cp --parents {} "$TMP_DIR"/ \;
else
    echo "Invalid mode: choose 'full' or 'partial'"
    rm -rf "$TMP_DIR"
    exit 1
fi

# ----------------------------
# Archive or move files
# ----------------------------
if [[ "$COMPRESS" == "yes" ]]; then
    ARCHIVE_PATH="$BACKUP_DIR/${ARCHIVE_NAME}.tar.gz"
    tar -czf "$ARCHIVE_PATH" -C "$TMP_DIR" .
    echo "Compressed backup saved to $ARCHIVE_PATH"
else
    BACKUP_PATH="$BACKUP_DIR/$ARCHIVE_NAME"
    mkdir -p "$BACKUP_PATH"
    cp -a "$TMP_DIR"/. "$BACKUP_PATH"/
    echo "Uncompressed backup saved to $BACKUP_PATH"
fi

# ----------------------------
# Cleanup
# ----------------------------
rm -rf "$TMP_DIR"
echo "Backup complete."
