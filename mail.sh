#!/bin/bash

TO_TEAM=$1
ALERT_TYPE=$2
#BODY=$(sed -e 's/[]\/$*.^[]/\\&/g' <<< $3)
#BODY=$3
ESCAPED_BODY=$(printf '%s\n' "$3" | sed -e 's/[]\/$*.^[]/\\&/g')
echo "Body: $ESCAPED_BODY"
SUBJECT=$4
TO_ADDRESS=$5

FINAL_BODY=$(sed -e "s/TO_TEAM/$TO_TEAM/g" -e "s/ALERT_TYPE/$ALERT_TYPE/g" -e "s/BODY/$ESCAPED_BODY/g" template.html)

echo "$FINAL_BODY" | mail -s "$(echo -e "$SUBJECT\nContent-Type: text/html")" "$TO_ADDRESS"