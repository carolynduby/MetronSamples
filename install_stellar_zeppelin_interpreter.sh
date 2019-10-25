#!/bin/sh

metron_version=`find /usr/hcp/current/metron/lib/ -name "*.jar" -printf "%f\n" | head -n 1 | sed -e 's/.jar//' -e 's/-uber//' -e 's/^[a-zA-Z-]*//g'`
cd /usr/hdp/current/zeppelin-server/interpreter/
sudo mkdir -p stellar

cd stellar
sudo cp /usr/hcp/current/metron/lib/*.jar .
sudo wget https://repo.hortonworks.com/content/repositories/releases/org/apache/metron/stellar-zeppelin/${metron_version}/stellar-zeppelin-${metron_version}.jar
cd ..
sudo chown -R zeppelin stellar 
sudo chgrp -R zeppelin stellar 

