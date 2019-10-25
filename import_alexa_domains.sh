#!/bin/sh

source /etc/default/metron

if [ "$#" -ne 1 ]; then
     echo "Usage: $0 csv_file "
     exit 1
fi

csv_file=$1
if ! [ -e "$csv_file" ]; then
    echo "CSV enrichment file '$csv_file' not found."
    exit 1
fi

./import_csv_enrichments.sh $csv_file alexa_domain domain rank,domain enrichment 
