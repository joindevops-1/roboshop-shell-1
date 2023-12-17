#!/bin/bash

SOURCE="/tmp/shell-logs"

FILES_TO_DELETE=$(find $SOURCE -type f -mtime +14)

echo "Files are: $FILES_TO_DELETE"

