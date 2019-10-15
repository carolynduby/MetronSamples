source /etc/default/metron

extractor_tmpdir=/tmp/threat_intel_import
mkdir -p $extractor_tmpdir
cp malicious_domain_extractor_config.json $extractor_tmpdir 

num_columns=`python csv_count_columns.py $1`
sed -i "s/{zookeeper}/$ZOOKEEPER/g" $extractor_tmpdir/malicious_domain_extractor_config.json 
if [ $num_columns -eq 3 ]; then
    sed -i "s/{columns}/\"domain\" : 0, \"malware_type\" : 2/g" $extractor_tmpdir/malicious_domain_extractor_config.json
else
    sed -i "s/{columns}/\"domain\" : 0, \"start_timestamp\" : 2, \"end_timestamp\" : 3, \"malware_type\" : 4/g" $extractor_tmpdir/malicious_domain_extractor_config.json
fi
 
/usr/hcp/current/metron/bin/flatfile_loader.sh -e $extractor_tmpdir/malicious_domain_extractor_config.json -t threatintel -i $1 -c t 
