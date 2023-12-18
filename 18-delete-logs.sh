#!/bin/bash
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE=$(basename "$0")
echo "basename: $LOGFILE"
#LOGFILE="$0.log"
exec &> ~/$LOGFILE

echo "script stareted executing at $TIMESTAMP"
days=14
FILES=""

display_usage() {
    echo "Usage: $0 -s <source-dir> -a <archive|delete> [-d <destination>] [-t <days>] [-m <memory-in-mb>]"
    echo "Options:"
    echo "  -s <source-dir>: Source directory path (required)"
    echo "  -a <archive|delete>: Action to perform (required)"
    echo "  -d <destination>: Destination directory path (required for 'archive' action)"
    echo "  -t <days>: Number of days (default: 14)"
    echo "  -m <memory-in-mb>: Memory limit in MB (optional)"
}

while getopts ":s:a:d:t:m:" opt; do
  case $opt in
    s) source_dir=$OPTARG ;;
    a) action=$OPTARG ;;
    d) destination=$OPTARG ;;
    t) days=$OPTARG ;;
    m) memory=$OPTARG ;;
    \?) echo "Invalid option: -$OPTARG" >&2; display_usage; exit 1 ;;
    :) echo "Option -$OPTARG requires an argument." >&2; display_usage; exit 1 ;;
  esac
done



find_files(){
    if [ -n "$memory" ]; 
    then
        FILES=$(find "$source_dir" -type f -size -"${memory}"k -name "*.log" -mtime +"$days")
    else
        FILES=$(find "$source_dir" -type f -name "*.log" -mtime +"$days")
    fi
}

# Check for required input
if [ -z "$source_dir" ] || [ -z "$action" ]; then
  echo "Error: Missing required input."
  display_usage
  exit 1
fi

# Check if source directory exists
if [ ! -d "$source_dir" ]; then
  echo "Error: Source directory does not exist."
  exit 1
fi

find_files

if [ "$action" == "delete" ]
then
    if [ -n "$FILES" ]; then
        while IFS= read -r line
        do
            echo "Deleting file: $line"
            rm -rf $line
        done <<< $FILES
    fi
elif [ "$action" == "archive" ]
then
    if [ -z "$destination" ]; then
        echo "Error: Destination directory not provided for archive action."
        display_usage
        exit 1
    fi
    if [ ! -d "$destination" ]; then
        echo "Error: Destination directory does not exist."
        exit 1
    fi
    if [ -n "$FILES" ]; then
        last_part=$(basename "$source_dir")
        timestamp=$(date +%F-%H-%M-%S)
        archive_name="$last_part-$timestamp.tar.gz"
        printf '%s\0' $FILES | tar -czf "$destination/$archive_name" --null -T -
        echo "Archive is Done: $archive_name"
    else
        echo "No files to archive."
    fi
fi

