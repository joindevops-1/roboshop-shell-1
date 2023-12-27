#!/bin/bash

INSTANCES=("mongodb-$1" "redis-$1" "mysql-$1" "rabbitmq-$1" "catalogue-$1" "user-$1" "cart-$1" "shipping-$1" "payment-$1" "web-$1")
HOSTED_ZONE="daws76s.online"
IMAGE_ID="ami-03265a0778a880afb"
#INSTANCE_TYPE="t2.micro"
SG_ID="sg-087e7afb3a936fce7"

ZONE_ID=$(aws route53 list-hosted-zones --query "HostedZones[?Name == '$HOSTED_ZONE.'].Id" --output text)

if [ -n "$ZONE_ID" ]; then
    echo "Hosted zone '$HOSTED_ZONE' exists with ID: $ZONE_ID"
    ZONE_ID=$(echo $ZONE_ID | cut -d / -f3)
else
    echo "Hosted zone '$HOSTED_ZONE' does not exist."
    exit 1
fi

#create instance
for instance in "${INSTANCES[@]}"
do
    echo "creating instance for: $instance"
    INSTANCE_TYPE="t2.micro"
    if [[ $instance == "mongodb" || $instance == "mysql" || $instance == "shipping" ]]
    then
        INSTANCE_TYPE="t3.small"
    fi
    if [ ! $instance == "web" ]
    then
        IP_ADDRESS=$(aws ec2 run-instances --image-id $IMAGE_ID --instance-type $INSTANCE_TYPE --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" --query 'Instances[0].PrivateIpAddress' --output text)
    else
        INSTANCE_ID=$(aws ec2 run-instances --image-id $IMAGE_ID --instance-type $INSTANCE_TYPE --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" --query 'Instances[0].InstanceId' --output text)
        sleep 60
        IP_ADDRESS=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
    fi
    echo "Instance: $IP_ADDRESS "
        # Record doesn't exist, create it
    aws route53 change-resource-record-sets --hosted-zone-id "$ZONE_ID" \
    --change-batch '{
        "Changes": [
        {
            "Action": "CREATE",
            "ResourceRecordSet": {
            "Name": "'"$instance.$HOSTED_ZONE"'",
            "Type": "A",
            "TTL": 300,
            "ResourceRecords": [
                {
                "Value": "'"$IP_ADDRESS"'"
                }
            ]
            }
        }
        ]
    }'
    echo "Record '$RECORD_NAME' created."
done
