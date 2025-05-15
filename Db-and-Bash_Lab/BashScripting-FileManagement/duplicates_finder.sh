#!/bin/bash

# =======================
# Duplicate File Finder
# =======================
# This script scans a given directory for duplicate files.
# It uses file size and SHA256 hash to detect duplicates.
# It gives the user an option to delete or move duplicate files.

# Usage:
# ./find_duplicates.sh /folder_path/
# Skills: File handling, arrays, hashing, user input, loops
# =======================

# -----------------------
# Function to show usage
# -----------------------
usage() {
    echo "Usage: $0 /path/to/folder"
    exit 1
}

# -----------------------
# Check for folder input
# -----------------------
if [[ -z "$1" ]]; then
    usage
fi

TARGET_DIR="$1"

# -----------------------
# Check if directory exists
# -----------------------
if [[ ! -d "$TARGET_DIR" ]]; then
    echo "Error: Directory '$TARGET_DIR' does not exist."
    exit 1
fi

declare -A FILE_HASHES   # Hash -> original file path
declare -A DUPLICATES    # Hash -> array of duplicate paths

echo "Scanning files in: $TARGET_DIR"

# -----------------------
# Step 1: Traverse all files and compute hashes
# -----------------------
while IFS= read -r -d '' FILE; do
    # Skip if not a regular file
    [[ -f "$FILE" ]] || continue

    # Compute file size and hash
    SIZE=$(stat -c%s "$FILE")
    HASH=$(sha256sum "$FILE" | awk '{print $1}')

    # Use both size and hash for reliability
    KEY="${SIZE}_${HASH}"

    if [[ -n "${FILE_HASHES[$KEY]}" ]]; then
        # Duplicate found
        DUPLICATES["$KEY"]+="${FILE}"$'\n'
    else
        # First occurrence
        FILE_HASHES["$KEY"]="$FILE"
    fi
done < <(find "$TARGET_DIR" -type f -print0)

# -----------------------
# Step 2: Report duplicates
# -----------------------
echo
echo "Scan complete."
echo "Duplicate files found:"

FOUND_DUPES=false
for KEY in "${!DUPLICATES[@]}"; do
    ORIGINAL="${FILE_HASHES[$KEY]}"
    DUPLICATE_LIST="${DUPLICATES[$KEY]}"

    echo
    echo "Original: $ORIGINAL"
    echo "Duplicates:"
    echo "$DUPLICATE_LIST"

    FOUND_DUPES=true

    # -----------------------
    # Step 3: Ask user what to do
    # -----------------------
    echo
    echo "Choose an action:"
    echo "1) Delete all duplicates"
    echo "2) Move duplicates to a folder"
    echo "3) Skip"
    read -p "Enter choice [1-3]: " ACTION

    case "$ACTION" in
        1)
            while read -r DUP_FILE; do
                [[ -f "$DUP_FILE" ]] && rm -f "$DUP_FILE" && echo "Deleted: $DUP_FILE"
            done <<< "$DUPLICATE_LIST"
            ;;
        2)
            read -p "Enter target folder to move duplicates: " MOVE_DIR
            mkdir -p "$MOVE_DIR"
            while read -r DUP_FILE; do
                [[ -f "$DUP_FILE" ]] && mv "$DUP_FILE" "$MOVE_DIR" && echo "Moved: $DUP_FILE → $MOVE_DIR/"
            done <<< "$DUPLICATE_LIST"
            ;;
        *)
            echo "Skipped."
            ;;
    esac
done

if ! $FOUND_DUPES; then
    echo "No duplicates found!"
fi
