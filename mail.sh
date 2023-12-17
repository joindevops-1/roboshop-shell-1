#!/bin/bash

TO_TEAM=$1
ALERT_TYPE=$2
BODY=$(sed -e 's/[]\/$*.^[]/\\&/g' <<< $3)
SUBJECT=$4
TO_ADDRESS=$5

FINAL_BODY=$(sed -e "s/TO_TEAM/$TO_TEAM/g" sed -e "s/ALERT_TYPE/$ALERT_TYPE/g" -e "s/BODY/$BODY/g")

echo "$FINAL_BODY" | mail -s "$(echo -e "$SUBJECT\nContent-Type: text/html")" "$TO_ADDRESS"