#!/bin/bash

SOURCE="/tmp/shell-logs"

FILES_TO_DELETE=$(find $SOURCE -type f -name "*.log" -mtime +14)

echo "Files are: $FILES_TO_DELETE"

while IFS= read -r line; do
    # Process each line (for example, print it)
    printf "Line: %s\n" "$line"
done <<< "$FILES_TO_DELETE"