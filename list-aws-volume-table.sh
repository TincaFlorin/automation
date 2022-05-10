#!/bin/bash
profile=$0
region=$1

aws ec2 describe-volumes --profile ${profile} --region ${region} --filters Name=tag-key,Values=Name --query 'Volumes[*].{ID:Attachments[0].InstanceId,Volume:VolumeId,Type:VolumeType,Name:Tags[?Key==`Name`]|[0].Value}' --output table 2>/dev/null

if [[ $? -ne 0 ]]; then
   echo "Usage sh [PROFILE] [REGION] ";
   exit 1;
fi
exit 0
