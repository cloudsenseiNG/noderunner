#!/bin/bash

cd node

./download-config.py zora-mainnet-0

export CONDUIT_NETWORK=zora-mainnet-0

cp .env.example .env