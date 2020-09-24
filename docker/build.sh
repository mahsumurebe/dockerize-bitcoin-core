#!/usr/bin/env bash

docker build \
  -f "../Dockerfile" \
  --no-cache \
  -t "mahsumurebe/bitcoind:0.20.1" \
  -t "mahsumurebe/bitcoind:latest" \
  ../
