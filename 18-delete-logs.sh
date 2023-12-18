#!/bin/bash
display_usage() {
    echo "Usage: $0 -s <source-dir> -a <archive|delete> [-d <destination>] [-t <days>] [-m <memory-in-mb>]"
    echo "Options:"
    echo "  -s <source-dir>: Source directory path (required)"
    echo "  -a <archive|delete>: Action to perform (required)"
    echo "  -d <destination>: Destination directory path (required for 'archive' action)"
    echo "  -t <days>: Number of days (default: 14)"
    echo "  -m <memory-in-mb>: Memory limit in MB (optional)"
}

days=14

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