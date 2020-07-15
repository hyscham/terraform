#!/bin/bash

echo '*********************** Centos 7.5 ***********************'
echo 'Deplying ElasticSearch and Kibana on Cloud VM'

echo 'Updating OS'
sudo yum update

echo 'Install cUrl and Wget'
suo yum install curl wget

echo 'Create Working Dir'
sudo mkdir /opt/efk_repos

echo 'Move to new Dir'
cd /opt/efk_repos

echo 'Download ElasticSearch 7.7.0 OSS'
curl -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-7.7.0-linux-x86_64.tar.gz

echo 'Untar downloaded package'
tar -xzf elasticsearch-oss-7.7.0-linux-x86_64.tar.gz


echo 'Rename ElasticSearch folder'
mv elasticsearch-oss-7.7.0-linux-x86_64 elasticsearch

echo 'download Kibana 7.7.0 OSS package'
curl -O https://artifacts.elastic.co/downloads/kibana/kibana-oss-7.7.0-linux-x86_64.tar.gz

echo 'Untar Kibana downloaded package'
tar -xzf kibana-oss-7.7.0-linux-x86_64.tar.gz

echo 'Rname Kibana folder'
mv kibana-oss-7.7.0-linux-x86_64 kibana

echo 'Move to elastic Folder'
cd elasticsearch


echo 'Untar downloaded package'
sudo bin/elasticsearch-plugin install https://d3g5vo6xdbdb9a.cloudfront.net/downloads/elasticsearch-plugins/opendistro-job-scheduler/opendistro-job-scheduler-1.8.0.0.zip

echo 'Install OpenDistro Alerting plugin fr ElasticSearch'
sudo bin/elasticsearch-plugin install https://d3g5vo6xdbdb9a.cloudfront.net/downloads/elasticsearch-plugins/opendistro-alerting/opendistro_alerting-1.8.0.0.zip

echo 'Install OpenDistro Alerting plugin for Kibana'
cd ../kibana
sudo bin/kibana-plugin install https://d3g5vo6xdbdb9a.cloudfront.net/downloads/kibana-plugins/opendistro-alerting/opendistro-alerting-1.8.0.0.zip
