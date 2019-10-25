#!/bin/sh

source /etc/default/metron

# verify correct number of arguments 
if [ "$#" -ne 5 ]; then
     echo "Usage: $0 csv_file enrichment_name key_column_name columns table"
     exit 1
fi 

#extract the arguments to logical variable names
csv_file=$1
enrichment_name=$2
key_column_name=$3
columns=$4
table=$5

#verify the csv file exists
if ! [ -e "$csv_file" ]; then
    echo "CSV enrichment file '$csv_file' not found."
    exit 1
fi

if [ "$table" != "threatintel"  ] && [ "$table" != "enrichment" ] ; then
    echo "Table $table is invalid.  Expecting threatintel or enrichments"
    exit 1
fi

# set up a temp directory for the generated extractor config file
extractor_tmpdir=`mktemp -d -t csv_import-XXXXXX`
extractor_config=$extractor_tmpdir/csv_extractor_config.json
cp csv_extractor_config_template.json $extractor_config 

# verify that the header and the csv file have the same number of columns
file_num_columns=`python csv_count_columns.py $csv_file`
header_num_columns=`echo $columns |  awk -F"," '{print NF}'`

if [[ ${header_num_columns} -ne ${file_num_columns} ]] ; then
     echo "Header columns ($header_num_columns) does not equal csv file columns ($file_num_columns)."
     exit 1
fi

# populate the extractor config template

columns_json=`echo "$columns" | awk -F, -f build_csv_columns.awk` 

sed -i -e "s/{zookeeper}/$ZOOKEEPER/g" -e "s/{columns}/$columns_json/" -e "s/{key_column_name}/$key_column_name/" -e "s/{enrichment_name}/$enrichment_name/"  $extractor_config 
 
/usr/hcp/current/metron/bin/flatfile_loader.sh -e $extractor_config -t $table -i $csv_file -c t 
