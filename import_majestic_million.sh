#!/bin/sh

source /etc/default/metron

# download a new copy of the majestic million
rm -rf majestic_million.csv
wget http://downloads.majestic.com/majestic_million.csv

# save the header then remove it
header=`head -n 1 majestic_million.csv | awk -F, -f create_majestic_million_header.awk`
tail -n +2 majestic_million.csv > majestic_million_no_header.csv
mv majestic_million_no_header.csv majestic_million.csv

csv_file=majestic_million.csv

if ! [ -e "$csv_file" ]; then
    echo "CSV enrichment file '$csv_file' not found."
    exit 1
fi

./import_csv_enrichments.sh $csv_file majestic_million domain $header enrichment 
