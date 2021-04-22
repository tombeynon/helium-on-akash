#!/bin/sh

# Copy swarm_key from S3
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_KEY
aws s3 cp s3://$S3_KEY_PATH /var/data/miner/swarm_key

if [ ! -f "/var/data/miner/swarm_key" ]; then
  # Swarm key doesn't exist yet
  echo "Swarm key will be uploaded to S3"
  UPLOAD_KEY=1
fi

if [ ! -z $HELIUM_VERSION ]; then
  miner upgrade $HELIUM_VERSION
fi

echo "Starting miner..."
miner start && miner print_keys

if [ ! -z $UPLOAD_KEY ] && [ -f "/var/data/miner/swarm_key" ]; then
  echo "Uploading key"
  aws s3 cp /var/data/miner/swarm_key s3://$S3_KEY_PATH
fi

tail -fn 500 /var/data/log/console.log
