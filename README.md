# Helium on Akash

## Caveats

- Currently only the swarm_key is synced to S3, meaning the entire blockchain needs to be downloaded each time you run the miner. It takes about 30 minutes currently with the suggested deploy.yml
- There is a delay between 'Starting miner...' and the logs for the miner showing. The miner is running during this time, just the logs don't show. They appear after 5-10 minutes.
- On a few occasions the container didn't start on Akash. The available_replicas attribute never changed to 1. Closing the deployment and recreating always worked. 
