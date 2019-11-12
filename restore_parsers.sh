#!/bin/sh

if [ $# -ne 1 ]; then 
    echo "Usage: " $0 " sensor"
    exit 1
fi

config_count=`find . -name $1.json | wc -l`
if [ $config_count -lt 1 ]; then 
    echo "ERROR: There are no configuration files for sensor '"$1"'"
    exit 1
fi

source /etc/default/metron
config_dir=`mktemp -d -t restoreconfigXXXXX`

# pull the latest config files
/usr/hcp/current/metron/bin/zk_load_configs.sh -m PULL -o $config_dir -z $ZOOKEEPER -f

# copy the files into the zk config dir
cp -r enrichments/$1.json $config_dir/enrichments
cp -r parsers/$1.json $config_dir/parsers
cp -r indexing/$1.json $config_dir/indexing
profiles_copied=false
if [ ! -f "$config_dir/profiler.json" ]; then
    cp -r profiles/profiler.json $config_dir
    profiles_copied=true
fi 
 
/usr/hcp/current/metron/bin/zk_load_configs.sh -m PUSH -i $config_dir -z $ZOOKEEPER 

if [ "$profiles_copied" = false ]; then
    cat profiles/profiler.json | python ../profiler_patch.py > $config_dir/profiler_patch.json
    /usr/hcp/current/metron/bin/zk_load_configs.sh -m PATCH -c PROFILER -pf $config_dir/profiler_patch.json -z $ZOOKEEPER  
fi
