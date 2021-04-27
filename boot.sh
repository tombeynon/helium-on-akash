#!/bin/sh

echo "Starting"

export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_KEY

# Set external port if Akash 2154 is mapped
if [ ! -z $AKASH_PORT_2154_EXTERNAL_PORT ]; then
  export NAT_EXTERNAL_PORT=$AKASH_PORT_2154_EXTERNAL_PORT
fi

if [ ! -z $AKASH_PORT_2154_TCP_ADDR ]; then
  export NAT_EXTERNAL_IP=$AKASH_PORT_2154_TCP_ADDR
fi

printenv

# Copy swarm_key from S3 (ignore 404)
aws s3 cp s3://$S3_KEY_PATH /var/data/miner/swarm_key

# Stop on error from here
set -e

# Set UPLOAD_KEY if swarm_key doesn't exist
if [ ! -f "/var/data/miner/swarm_key" ]; then
  echo "Swarm key will be uploaded to S3"
  UPLOAD_KEY=1
fi

# This could upgrade the miner to a specific version...
# but I can't be sure it does that/works correctly so don't want to rely on it
#if [ ! -z $HELIUM_VERSION ]; then
#  miner upgrade $HELIUM_VERSION
#fi

# Start miner and print address
echo "Starting miner..."
miner start && miner print_keys

# Upload swarm_key to S3 if it didn't exist before
if [ ! -z $UPLOAD_KEY ] && [ -f "/var/data/miner/swarm_key" ]; then
  echo "Uploading key"
  aws s3 cp /var/data/miner/swarm_key s3://$S3_KEY_PATH
fi

# Tail logs and keep Docker process alive
tail -Fn 500 /var/data/log/console.log
