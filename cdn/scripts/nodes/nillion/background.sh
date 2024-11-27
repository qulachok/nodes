#! /bin/bash

rpc_endpoint="https://nillion-testnet.rpc.kjnodes.com"

docker run -d --name nillion-verifier --restart unless-stopped -v ./nillion/verifier:/var/tmp nillion/verifier:v1.0.1 verify --rpc-endpoint $rpc_endpoint