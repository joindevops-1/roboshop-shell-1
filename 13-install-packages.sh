#!/bin/bash
set -e

catch_errors() {
    ret=$?
    echo "Error occurred in script at line $1, message: $2"
    exit $ret
}

# Trap errors and call the function with the line number
trap 'catch_errors $LINENO' ERR
SCRIPT_NAME_WITHOUT_EXT="${$0%.*}"

exec 3>> "/tmp/$SCRIPT_NAME_WITHOUT_EXT-$(date +%F-%H-%M-%S).log"

# Redirect all logs to file descriptor 3
exec &>3

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script stareted executing at $TIMESTAMP" 

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1 # you can give other than 0
else
    echo "You are root user"
fi

for package in $@
do
    yum list installed $package  #check installed or not
    if [ $? -ne 0 ] #if not installed
    then
        yum install $package -y &>>$LOGFILE
    else
        echo -e "$package is already installed ... $Y SKIPPING $N"
    fi
done

exec 3>&-