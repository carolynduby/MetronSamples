curl -s https://ransomwaretracker.abuse.ch/downloads/RW_DOMBL.txt | grep -v  "^#" | grep -v "^$" | awk '{print $0 ",ransomwaretracker.abuse.ch"}' > ransomware_domains.csv

./import_csv_enrichments.sh ransomware_domains.csv malicious_domain domain domain,source threatintel 
