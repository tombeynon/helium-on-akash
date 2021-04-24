#!/bin/bash

# Copy swarm_key from S3
echo "Starting"
printenv
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_KEY
aws s3 cp s3://$S3_KEY_PATH /var/data/miner/swarm_key

# Stop on error
set -e

if [ ! -f "/var/data/miner/swarm_key" ]; then
  # Swarm key doesn't exist yet
  echo "Swarm key will be uploaded to S3"
  UPLOAD_KEY=1
fi

# This could upgrade the miner to a specific version...
# but I can't be sure it does that/works correctly so don't want to rely on it
#if [ ! -z $HELIUM_VERSION ]; then
#  miner upgrade $HELIUM_VERSION
#fi

echo "Starting miner..."
miner start && miner print_keys

if [ ! -z $UPLOAD_KEY ] && [ -f "/var/data/miner/swarm_key" ]; then
  echo "Uploading key"
  aws s3 cp /var/data/miner/swarm_key s3://$S3_KEY_PATH
fi

tail -Fn 500 /var/data/log/console.log
