#!/bin/bash

SOURCE="/tmp/shell-logss"

if [ ! -d "$directory" ]; then
    echo "$SOURCE does not exists."
fi
FILES_TO_DELETE=$(find $SOURCE -type f -name "*.log" -mtime +14)

#echo "Files are: $FILES_TO_DELETE"

while IFS= read -r line; do
    # Process each line (for example, print it)
    echo "Deleting file: $line"
    rm -rf $line
done <<< "$FILES_TO_DELETE"