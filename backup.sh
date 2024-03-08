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
    echo "It's there!"
  elif [[ $f == *"u2u-images"* ]]; then
    echo "Again"
  elif [[ $f == *"elasticbeanstalk"* ]]; then
    echo "Elastic"
  else
    echo $BACKUP_DIR
    mkdir -p $BACKUP_DIR
    $aws s3 sync s3://$f $BACKUP_DIR --profile=$profile
  fi
  
done
