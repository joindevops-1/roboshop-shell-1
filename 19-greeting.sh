#!/bin/bash

usage() {
  echo "Usage: $(basename "$0") -n <name> -w <wishes>"
  echo "Options:"
  echo "  -n, --name <name>      Specify the name (mandatory)"
  echo "  -w, --wishes <wishes>  Specify the wishes (mandatory)"
  echo "  -h, --help             Display this help and exit"
}

NAME=""
WISHES="Good Evening"
while getopts ":n:w:h" opt; do
  case $opt in
    n) NAME="$OPTARG";;
    w) WISHES="$OPTARG";;
    h|\?) usage; exit;;
  esac
done

if [ -z "$NAME" ] || [ -z "$WISHES" ]; then
  echo "Error: Both -n (name) and -w (wishes) are mandatory options."
  usage
  exit 1
fi

echo "Hello $NAME, $WISHES. I am learning Shell script"
