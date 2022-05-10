#!/bin/bash
# This script migrates all aws volumes in the specified profile and region from gp2 to gp3 
echo "AWS profile: "
read profile

echo "AWS region: "
read region

for volumeId in $(aws ec2 describe-volumes --filters Name=volume-type,Values=standard --profile ${profile} --region ${region} --query 'Volumes[*].VolumeId' --output text); 
  do;
  size=$(aws ec2 describe-volumes --filters Name=volume-id,Values=${volumeId} --profile ${profile} --region ${region} --query 'Volumes[*].Size' --output text); 
  echo "Volume id: ${volumeId} - size ${size}gb migrated to gp3"
  aws ec2 modify-volume --volume-type gp3 --iops 3000 --size ${size} --volume-id ${volumeId} --profile ${profile} --region ${region} >> /dev/null;
done;
