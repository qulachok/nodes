#! /bin/bash

backup_path="$HOME/nillion-backup"

mkdir -p $backup_path

cp $HOME/nillion/verifier/credentials.json $backup_path/credentials.json