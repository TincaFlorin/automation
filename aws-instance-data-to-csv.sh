#!/bin/bash
profile=$1
region=$2

echo "Instance Id,Instance Name,Instance Ip,Instance OS,Instance State,Volumes,Snapshots" >> "${region}".csv

for instanceId in $(aws ec2 describe-instances --profile ${profile} --region ${region}\
    --filters Name=tag-key,Values=Name \
    --query 'Reservations[*].Instances[*].InstanceId' \
    --output text)
do

    echo -ne $instanceId ","
    echo -ne $(aws ec2 describe-instances --profile ${profile} --region ${region}\
    --filters Name=instance-id,Values=${instanceId} \
    --query 'Reservations[*].Instances[*].{Name:Tags[?Key==`Name`]|[0].Value}' \
    --output text) ","
    echo -ne $(aws ec2 describe-instances --profile ${profile} --region ${region}\
    --filters Name=instance-id,Values=${instanceId} \
    --query 'Reservations[*].Instances[*].PrivateIpAddress' \
    --output text) ","
    echo -ne $(aws ec2 describe-instances --profile ${profile} --region ${region}\
    --filters Name=instance-id,Values=${instanceId} \
    --query 'Reservations[*].Instances[*].PlatformDetails' \
    --output text) ","
    echo -ne $(aws ec2 describe-instances --profile ${profile} --region ${region}\
    --filters Name=instance-id,Values=${instanceId} \
    --query 'Reservations[*].Instances[*].State.Name' \
    --output text) ","  


    for volumeId in $(aws ec2 describe-instances --profile ${profile} --region ${region}\
    --filters Name=instance-id,Values=${instanceId} \
    --query 'Reservations[*].Instances[*].BlockDeviceMappings[*].Ebs.VolumeId' \
    --output text)
    do
        echo -ne $volumeId " "
    done
    echo -ne ","

    for volumeId in $(aws ec2 describe-instances --profile ${profile} --region ${region}\
    --filters Name=instance-id,Values=${instanceId} \
    --query 'Reservations[*].Instances[*].BlockDeviceMappings[*].Ebs.VolumeId' \
    --output text)
    do
        for snapshotId in $(aws ec2 describe-snapshots --profile ${profile} --region ${region} --filters Name=volume-id,Values=${volumeId} --query 'Snapshots[*].SnapshotId' --output text)
        do            
            echo -ne $snapshotId " "
        done
    done
    echo 
done >> "${region}".csv

if [ $? -ne 0 ]; then
    echo "Usage: script [PROFILE] [REGION]"
    exit 1
fi

exit 0
