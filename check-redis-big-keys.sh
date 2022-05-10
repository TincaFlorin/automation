#!/bin/bash

# This script checks for redis memory usage and if it goes over 2GB writes the big keys into 2 files
# 1st file is located at /mnt/sugar/shadowed/monitoringRedis/redis_monitoring.txt
# 2nd file is located at /home/ftinca/backup_redis_monitoring.txt
# You will only find those files if the redis memory usage exceeded 2GB at some point
while true

do

used_redis_memory=$(redis-cli -h ondemandus01-sc.rxzskg.ng.0001.usw2.cache.amazonaws.com -p 6379 INFO | grep used_memory: | awk -F ":" '{print $2}')
used_redis_memory="${used_redis_memory//[$'\t\r\n ']}"

    if [ $used_redis_memory -gt 2000000000 ]
        then
	printf '%s %s\n' "$( date)" "$line" >> /mnt/sugar/shadowed/monitoringRedis/redis_monitoring.txt
        redis-cli -h ondemandus01-sc.rxzskg.ng.0001.usw2.cache.amazonaws.com -p 6379 --bigkeys >> /mnt/sugar/shadowed/monitoringRedis/redis_monitoring.txt
        printf "%s\n\n\n" >> /mnt/sugar/shadowed/monitoringRedis/redis_monitoring.txt

    	printf '%s %s\n' "$( date)" "$line" >> /home/ftinca/backup_redis_monitoring.txt
        redis-cli -h ondemandus01-sc.rxzskg.ng.0001.usw2.cache.amazonaws.com -p 6379 --bigkeys >> /home/ftinca/backup_redis_monitoring.txt
        printf "%s\n\n\n" >> /home/ftinca/backup_redis_monitoring.txt
    fi

    sleep 10

done
