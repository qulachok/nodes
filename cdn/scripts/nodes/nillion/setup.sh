#! /bin/bash

docker pull nillion/verifier:v1.0.1

mkdir -p nillion/verifier

docker run -v ./nillion/verifier:/var/tmp nillion/verifier:v1.0.1 initialise
