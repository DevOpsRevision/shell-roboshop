AMI_ID=ami-0220d79f3f480ecf5
SG_ID=sg-0c05c24867a0de439
ZONE_ID=Z09260871ALCRUTIR75TM
DOMAIN_NAME=easydevops.fun
INSTANCES=("frontend" "catalogue" "cart" "payment" "shipping" "user" "dispatch" "rabbitmq" "mongodb" "mysql" "redis")

for instance in ${INSTANCES[@]}
do
  echo "Creating $instance instance..."
  INSTANCE_ID=$(aws ec2 run-instances --image-id $AMI_ID --instance-type t2.micro --security-group-ids $SG_ID --tag-specifications "ResourceType=instance, Tags=[{Key=Name, Value=test}]" --query "Instances[0].InstanceId" --output text)

  if [ $instance != "frontend" ]
    then
       IP_ADDRESS=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)
       echo "IP address of $instance instance: $IP_ADDRESS"
    else
       IP_ADDRESS=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
       echo "Public IP address of $instance instance: $IP_ADDRESS"
  fi

done
