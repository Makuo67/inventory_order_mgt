#!/bin/bash

# ===========================================
# Disk Usage Tree View
# ===========================================
# Description:
# This script displays a tree-like structure of folders and files along with their disk usage.
# It supports:
# - Recursively listing directory sizes
# - Sorting results by size (descending)
# - Filtering files/folders above a certain size threshold
#
# Usage:
# ./disk_usage_tree.sh [target_directory] [min_size_MB] [max_depth]
#
# Example:
# ./disk_usage_tree.sh /home/user 10 3
#   → Shows items using >=10MB up to 3 directory levels deep
#
# ===========================================

# ----------------------------
# Input Validation
# ----------------------------
if [[ $# -lt 3 ]]; then
    echo "Usage: $0 [target_directory] [min_size_MB] [max_depth]"
    exit 1
fi

TARGET_DIR="$1"
MIN_SIZE_MB="$2"
MAX_DEPTH="$3"

# Validate target directory
if [[ ! -d "$TARGET_DIR" ]]; then
    echo "Error: '$TARGET_DIR' is not a valid directory."
    exit 1
fi

# ----------------------------
# Convert MB threshold to kilobytes (du works in KB by default)
# ----------------------------
MIN_SIZE_KB=$((MIN_SIZE_MB * 1024))

# ----------------------------
# Function: Print disk usage in tree format
# ----------------------------
print_tree_usage() {
    local dir="$1"
    local depth="$2"
    local prefix="$3"

    # Stop if max depth reached
    if [[ $depth -gt $MAX_DEPTH ]]; then
        return
    fi

    # Get size of current dir
    local size_kb
    size_kb=$(du -sk "$dir" | cut -f1)

    # Skip if under threshold
    if [[ $size_kb -lt $MIN_SIZE_KB ]]; then
        return
    fi

    # Format output
    local size_human
    size_human=$(du -sh "$dir" 2>/dev/null | cut -f1)
    echo "${prefix}${dir##*/} [${size_human}]"

    # Recurse into subdirs
    local child
    for child in "$dir"/*; do
        if [[ -d "$child" ]]; then
            print_tree_usage "$child" $((depth + 1)) "${prefix}│   "
        elif [[ -f "$child" ]]; then
            local file_size_kb
            file_size_kb=$(du -sk "$child" 2>/dev/null | cut -f1)
            if [[ $file_size_kb -ge $MIN_SIZE_KB ]]; then
                local file_size_human
                file_size_human=$(du -sh "$child" 2>/dev/null | cut -f1)
                echo "${prefix}├── ${child##*/} [${file_size_human}]"
            fi
        fi
    done
}

# ----------------------------
# Start scanning
# ----------------------------
echo "Disk Usage Tree for '$TARGET_DIR' (>= ${MIN_SIZE_MB}MB, max depth = $MAX_DEPTH)"
echo "------------------------------------------------------------"
print_tree_usage "$TARGET_DIR" 1 ""
