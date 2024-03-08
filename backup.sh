#!/bin/bash

profile=$1
aws=/usr/local/bin/aws
echo $profile
echo $aws

SCRIPT_DIR="$(pwd)"
echo "Script directory: $SCRIPT_DIR"

result=$($aws s3 ls --profile=$profile | awk '{print $3}';)

for f in $result; do
  echo "Bucket -> $f"
  BACKUP_DIR=$SCRIPT_DIR/$profile/$f
  if [[ $f == *"ws-cloudtrail-logs"* ]]; then
    echo "Cloudtrail"
  elif [[ $f == *"u2u-images"* ]]; then
    mkdir -p $BACKUP_DIR
    $aws s3 sync s3://$f $BACKUP_DIR --profile=$profile
  elif [[ $f == *"elasticbeanstalk"* ]]; then
    echo "Elastic"
  else
    echo "Synced"
  fi
  
done
