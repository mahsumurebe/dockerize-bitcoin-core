#!/bin/bash

ADMIN_ADDRESS=""
RPC_URL="http://btcuser:uYwTvJe5VzOchIA7dLIu@chain-btc:8332"

BALANCE=$(curl -s -X POST -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","id":"1","method":"getbalance","params":[]}' $RPC_URL | jq .result)
if (( $(echo "$BALANCE > 0" | bc -l) )); then
   echo "Moving $BALANCE"
   echo "\n" >>/data/logs/move.log
   curl -s -X POST -H 'Content-Type: application/json' -d "{\"jsonrpc\":\"2.0\",\"id\":\"1\",\"method\":\"sendtoaddress\",\"params\":[\"$ADMIN_ADDRESS\",\"$BALANCE\",\"\" ,\"\" , true]}" $RPC_URL >> /data/logs/move.log
fi
