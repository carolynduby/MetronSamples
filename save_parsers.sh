#!/bin/sh

source /etc/default/metron
config_dir=/tmp/save_config_tool

# pull the latest config files
sudo /usr/hcp/current/metron/bin/zk_load_configs.sh -m PULL -o $config_dir -z $ZOOKEEPER -f

# create the repo directories if necessary
mkdir -p enrichments
mkdir -p indexing
mkdir -p parsers

# pretty print the config files and move to repository
cat $config_dir/enrichments/$1.json | python -m json.tool > enrichments/$1.json
cat $config_dir/parsers/$1.json | python -m json.tool > parsers/$1.json
cat $config_dir/indexing/$1.json | python -m json.tool > indexing/$1.json

