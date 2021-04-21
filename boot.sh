#!/bin/sh

miner start

miner print_keys

tail -fn 500 /var/data/log/console.log
