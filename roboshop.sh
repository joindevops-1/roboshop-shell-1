#!/bin/bash

INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "web")
HOSTED_ZONE="daws76s.online"
IMAGE_ID="ami-03265a0778a880afb"
#INSTANCE_TYPE="t2.micro"
SG_ID="sg-087e7afb3a936fce7"

#create instance
for instance in "${INSTANCES[@]}"
do
    echo "creating instance for: $instance"
    INSTANCE_TYPE="t2.micro"
    if [[ $instance == "mongodb" || $instance == "mysql" || $instance == "shipping" ]]
    then
        INSTANCE_TYPE="t3.small"
    fi
    if [ ! instance == "web" ]
    then
        IP_ADDRESS=$(aws ec2 run-instances --image-id $IMAGE_ID --instance-type $INSTANCE_TYPE --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" --query 'Instances[0].PrivateIpAddress' --output text)
    else
        INSTANCE_ID=$(aws ec2 run-instances --image-id $IMAGE_ID --instance-type $INSTANCE_TYPE --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" --query 'Instances[0].InstanceId' --output text)
        sleep 60
        IP_ADDRESS=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Instances[0].PublicIpAddress' --output text)
    fi
    echo "Instance: $IP_ADDRESS "
done
