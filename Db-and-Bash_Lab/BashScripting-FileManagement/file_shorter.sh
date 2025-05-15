#!/bin/bash

# Set the directory to organize (defaults to current if none given)
DIR="${1:-.}"

# Define folder mapping
declare -A FILE_TYPES
FILE_TYPES=( 
    ["Documents"]="pdf docx txt xlsx pptx"
    ["Images"]="jpg jpeg png gif bmp"
    ["Videos"]="mp4 mov avi mkv"
    ["Music"]="mp3 wav aac"
    ["Archives"]="zip rar tar gz"
    ["Scripts"]="py js html css java cpp sh"
)

# Create folders and move files
for FILE in "$DIR"/*; do
    if [[ -f "$FILE" ]]; then
        EXT="${FILE##*.}"
        EXT_LOWER=$(echo "$EXT" | awk '{print tolower($0)}')
        MOVED=false

        for CATEGORY in "${!FILE_TYPES[@]}"; do
            for TYPE in ${FILE_TYPES[$CATEGORY]}; do
                if [[ "$EXT_LOWER" == "$TYPE" ]]; then
                    TARGET="$DIR/$CATEGORY"
                    mkdir -p "$TARGET"
                    mv "$FILE" "$TARGET/"
                    MOVED=true
                    break 2
                fi
            done
        done

        # If extension is not found in the map
        if [[ "$MOVED" = false ]]; then
            TARGET="$DIR/Others"
            mkdir -p "$TARGET"
            mv "$FILE" "$TARGET/"
        fi
    fi
done

echo "Sorting completed!"