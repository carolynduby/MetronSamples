#!/bin/sh

source /etc/default/metron
if [ "$#" -ne 4 ]; then
     echo "Usage: $0 csv_file enrichment_name key_column_name columns"
     exit 1
fi 

csv_file=$1
enrichment_name=$2
key_column_name=$3
columns=$4

if ! [ -e "$csv_file" ]; then
    echo "CSV enrichment file '$csv_file' not found."
    exit 1
fi

extractor_tmpdir=`tmpdir=`mktemp -d -t csv_import-XXXXXX`
extractor_config=$extractor_tmpdir/csv_extractor_config.json
cp csv_extractor_config_template.json $extractor_config 

num_columns=`python csv_count_columns.py $1`
sed -i "s/{zookeeper}/$ZOOKEEPER/g" $extractor_tmpdir/malicious_domain_extractor_config.json 
if [ $num_columns -eq 3 ]; then
    sed -i "s/{columns}/\"domain\" : 0, \"malware_type\" : 2/g" $extractor_tmpdir/malicious_domain_extractor_config.json
else
    sed -i "s/{columns}/\"domain\" : 0, \"start_timestamp\" : 2, \"end_timestamp\" : 3, \"malware_type\" : 4/g" $extractor_tmpdir/malicious_domain_extractor_config.json
fi
 
/usr/hcp/current/metron/bin/flatfile_loader.sh -e $extractor_tmpdir/malicious_domain_extractor_config.json -t threatintel -i $1 -c t 
