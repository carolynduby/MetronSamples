#!/bin/sh

source /etc/default/metron
config_dir=/tmp/restore_config_tool

# pull the latest config files
sudo /usr/hcp/current/metron/bin/zk_load_configs.sh -m PULL -o $config_dir -z $ZOOKEEPER -f

# copy the files into the zk config dir
cp -r enrichments/$1.json $config_dir/enrichments
cp -r parsers/$1.json $config_dir/parsers
cp -r indexing/$1.json $config_dir/indexing
profiles_copied=false
if [ ! -f "$config_dir/profiler.json" ]; then
    cp -r profiles/profiler.json $config_dir
    profiles_copied=true
fi 
 
sudo /usr/hcp/current/metron/bin/zk_load_configs.sh -m PUSH -i $config_dir -z $ZOOKEEPER 

if [ "$profiles_copied" = false ]; then
    cat profiles/profiler.json | python ../profiler_patch.py > $config_dir/profiler_patch.json
    /usr/hcp/current/metron/bin/zk_load_configs.sh -m PATCH -c PROFILER -pf $config_dir/profiler_patch.json -z $ZOOKEEPER  
fi
