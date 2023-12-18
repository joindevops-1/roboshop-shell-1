#!/bin/bash

SOURCE="/tmp/shellscript-logs"

if [ ! -d "$SOURCE" ]; then
    echo -e "\e[31m $SOURCE does not exists. \e[0m"
    exit 1
fi
FILES_TO_DELETE=$(find $SOURCE -type f -name "*.log" -mtime +14)

#echo "Files are: $FILES_TO_DELETE"

while IFS= read -r line; do
    # Process each line (for example, print it)
    echo "Deleting file: $line"
    rm -rf $line
done <<< "$FILES_TO_DELETE"