#!/bin/bash

action=$1
num=$2

for (( i=0; i<=$num; i++ ))
do
  if [ "$action" = "start" ]
  then
echo "Starting delayed_job.$i"
/usr/bin/env RAILS_ENV=production HOME=/home/deploy PATH=/usr/local/bin:$PATH /srv/www/flaggpole.com/flaggpole/script/delayed_job start -i $i
  elif [ "$action" = "stop" ]
  then
/usr/bin/env RAILS_ENV=production HOME=/home/deploy PATH=/usr/local/bin:$PATH /srv/www/flaggpole.com/flaggpole/script/delayed_job stop -i $i
  fi
done

