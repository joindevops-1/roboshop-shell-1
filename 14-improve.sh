#!/bin/bash

# set -e

# catch_errors() {
#     ret=$?
#     echo "Error occurred in script at line $1, message: $2"
#     exit $ret
# }

# # Trap errors and call the function with the line number
# trap 'catch_errors $LINENO' ERR

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script stareted executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILED $N"
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1 # you can give other than 0
else
    echo "You are root user"
fi 

for package in $@
do
    yum list installed $package &>> $LOGFILE
    if [ $? -ne 0 ]
    then
        yum install $package -y &>> $LOGFILE
        echo "$package installation ... $G SUCCESS $N"
        VALIDATE $? "Installation of $package" # validate
    else
        echo -e "$package is already installed ... $Y SKIPPING $N"
    fi
done