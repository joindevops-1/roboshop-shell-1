#!/bin/bash

INSTANCES=("mongodb" "redi" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "web")
HOSTED_ZONE="daws76s.online"
IMAGE_ID="ami-03265a0778a880afb"
INSTANCE_TYPE="t2.micro"
SG_ID="sg-087e7afb3a936fce7"

#create instance
for instance in "${INSTANCES[@]}"
do
    if [[ $instance = "mongodb" || $instance = "mysql" || $instance = "shippinh" ]]
    then
        INSTANCE_TYPE="t3.small"
    fi
    aws ec2 run-instances --image-id $IMAGE_ID --instance-type $INSTANCE_TYPE --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$$instance}]"
done
