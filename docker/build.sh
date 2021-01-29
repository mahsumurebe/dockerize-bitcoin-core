#!/usr/bin/env bash

docker build \
  -f "../Dockerfile" \
  --no-cache \
  -t "mahsumurebe/bitcoind:0.21.0" \
  -t "mahsumurebe/bitcoind:latest" \
  ../
