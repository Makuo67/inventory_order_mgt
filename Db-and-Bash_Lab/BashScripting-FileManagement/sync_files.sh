#!/bin/bash

# ===========================================
# Two-Way Folder Sync Script
# ===========================================
# Description:
# This script synchronizes two directories (source and target),
# ensuring that both directories reflect the latest version of all files.
#
# Features:
# - Two-way synchronization
# - File modification time comparison
# - Basic conflict detection and resolution
# - Logging of actions performed
#
# Usage:
# ./folder_sync.sh <folder1> <folder2>
#
# Requirements:
# - Bash 4+
# ===========================================

# ----------------------------
# CONFIGURATION
# ----------------------------

LOG_FILE="./folder_sync.log"

# ----------------------------
# LOG FUNCTION
# ----------------------------
log_action() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# ----------------------------
# FUNCTION: Synchronize folders
# ----------------------------
sync_folders() {
    local folder1="$1"
    local folder2="$2"

    # Verify directories
    if [[ ! -d "$folder1" || ! -d "$folder2" ]]; then
        echo "Error: Both paths must be valid directories."
        exit 1
    fi

    # Remove trailing slashes for consistency
    folder1="${folder1%/}"
    folder2="${folder2%/}"

    echo "Synchronizing $folder1 <--> $folder2"
    log_action "Started synchronization between $folder1 and $folder2"

    # Loop over files in folder1
    while IFS= read -r -d '' file1; do
        rel_path="${file1#$folder1/}"
        file2="$folder2/$rel_path"

        # If file doesn't exist in folder2, copy it
        if [[ ! -e "$file2" ]]; then
            mkdir -p "$(dirname "$file2")"
            cp -p "$file1" "$file2"
            log_action "Copied $file1 to $file2 (new)"
        elif [[ "$file1" -nt "$file2" ]]; then
            cp -p "$file1" "$file2"
            log_action "Updated $file2 with newer version from $file1"
        elif [[ "$file2" -nt "$file1" ]]; then
            cp -p "$file2" "$file1"
            log_action "Updated $file1 with newer version from $file2"
        fi
    done < <(find "$folder1" -type f -print0)

    # Loop over files in folder2 to detect new files not in folder1
    while IFS= read -r -d '' file2; do
        rel_path="${file2#$folder2/}"
        file1="$folder1/$rel_path"

        if [[ ! -e "$file1" ]]; then
            mkdir -p "$(dirname "$file1")"
            cp -p "$file2" "$file1"
            log_action "Copied $file2 to $file1 (new)"
        fi
    done < <(find "$folder2" -type f -print0)

    log_action "Synchronization complete"
    echo "Synchronization complete. See $LOG_FILE for details."
}

# ----------------------------
# MAIN EXECUTION
# ----------------------------
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <folder1> <folder2>"
    exit 1
fi

sync_folders "$1" "$2"
