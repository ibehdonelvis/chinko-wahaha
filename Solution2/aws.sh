#!/bin/bash

profiles=$(aws configure list-profiles --output text)

Tags=Name=tag:Name,Values=$EC2Name

Regions=$Region #assuming region is known and the user has access

#If the region isn't known, we can query through the regions available to this account, assuming ~/.aws/config was configured to  contain all required profiles
#aws --profile $i ec2 describe-regions --output text | cut -f4

echo "PLEASE INPUT THE SPECIFIC EC2 NAME"

read EC2Name

for i in $profiles
do
  EC2_PUBLIC_IP=$(aws ec2 describe-instances \
	--profile $i \
	--query "Reservations[*].Instances[*].PublicIpAddress" \
	--filter Name=instance-state-name,Values=running Name=tag:Name,Values=$EC2Name \
	--output=text)
   if [[ $EC2_PUBLIC_IP ]]; then
      echo "trying to establish ssh connection to $EC2_PUBLIC_IP"
	break
      else
	echo "Hostnotfound in $i"
    fi
done

ssh ec2-user@$EC2_PUBLIC_IP
