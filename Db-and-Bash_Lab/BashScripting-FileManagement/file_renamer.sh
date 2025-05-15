#!/bin/bash

# Usage:
# ./rename_files.sh <arguments>
# Example:
# ./rename_files.sh ./files IMG _edited 1 yes jpg

DIR="${1:-.}"
PREFIX="${2:-file}"
SUFFIX="${3:-}"
COUNTER="${4:-1}"
USE_DATE="${5:-no}"
EXTENSION="${6:-*}"  # Use * for any extension

# Format date
TODAY=$(date +%Y-%m-%d)

# Make sure directory exists
if [ ! -d "$DIR" ]; then
  echo "Directory '$DIR' does not exist."
  exit 1
fi

# Loop through matching files
shopt -s nullglob
FILES=("$DIR"/*."$EXTENSION")

if [ ${#FILES[@]} -eq 0 ]; then
  echo "No files with extension .$EXTENSION found in $DIR"
  exit 0
fi

for FILE in "${FILES[@]}"; do
  BASENAME=$(basename "$FILE")
  EXT="${BASENAME##*.}"

  # Construct new filename
  NEW_NAME="${PREFIX}_${COUNTER}"
  if [ "$USE_DATE" == "yes" ]; then
    NEW_NAME="${NEW_NAME}_${TODAY}"
  fi
  NEW_NAME="${NEW_NAME}${SUFFIX}.${EXT}"

  # Rename file
  mv "$FILE" "$DIR/$NEW_NAME"
  echo "Renamed: $BASENAME → $NEW_NAME"

  ((COUNTER++))
done

echo "All files has been renamed!"