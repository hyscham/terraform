echo '*********************** Centos 7.5 *************************'
echo 'Deploying ElasticSearch and Kibana on Cloud VM..............'
echo '**************************** By h.ennakouch@gmail.com ******'

echo '************************************************************'
echo '********************* JDK configuration ********************'
echo '************************************************************'


echo '1- Installing OpenJdk 1.8 ...'
#sudo yum install java-1.8.0-openjdk -y
sudo yum install java-1.8.0-openjdk-devel unzip -y
echo '.....done'

echo '************************************************************'
echo '********** Elastic Search 7.7.0 OSS Install ****************'
echo '************************************************************'

echo '1- Move to new home dir'
echo '.... done'
cd $HOME

echo '2- Create a working dir'
echo '.... done'
mkdir efk

cd efk


echo '3- Download ElasticSearch 7.7.0 OSS'
curl -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-7.7.0-linux-x86_64.tar.gz
echo '.... done'

echo '4- Untar downloaded package....'
tar -xzf elasticsearch-oss-7.7.0-linux-x86_64.tar.gz
mv elasticsearch*/ elasticsearch
cd elasticsearch

sudo ln -s /usr/lib/jvm/java-1.8.0/lib/tools.jar lib/

echo "`ls -lha`"

echo '5- Download and Install OpenDistro JOB SCHEDULER plugin ...'
sudo bin/elasticsearch-plugin install --batch https://d3g5vo6xdbdb9a.cloudfront.net/downloads/elasticsearch-plugins/opendistro-job-scheduler/opendistro-job-scheduler-1.8.0.0.zip
echo '..... Done'

echo '6- Download and Install OpenDistro Alerting plugin for ElasticSearch ... '
sudo bin/elasticsearch-plugin install --batch https://d3g5vo6xdbdb9a.cloudfront.net/downloads/elasticsearch-plugins/opendistro-alerting/opendistro_alerting-1.8.0.0.zip
echo '... Done.'


echo '6- Configuring network-host parameter for elasticsearch '
echo 'network.host: 127.0.0.1' >> config/elasticsearch.yaml
echo '... Done'

echo '7- First run .... port 9200 should be opened on nsg '
cd bin
./elasticsearch

echo '*****************************************************************'
echo '**************** Kibana 7.7.0 OSS install  **********************'
echo '*****************************************************************'

echo '1- Download Kibana 7.7.0 OSS package'
cd ~/efk
sudo curl -O https://artifacts.elastic.co/downloads/kibana/kibana-oss-7.7.0-linux-x86_64.tar.gz
echo '... done'

echo '2- untar Kibana downloaded package'
sudo tar -xzf kibana-oss-7.7.0-linux-x86_64.tar.gz
echo '... done'

echo '3- Rename Kibana folder'
sudo mv kibana*/ kibana

echo '4- Move to elastic Folder'
cd kibana

echo '5- Install OpenDistro Alerting plugin for Kibana'
sudo bin/kibana-plugin install --batch https://d3g5vo6xdbdb9a.cloudfront.net/downloads/kibana-plugins/opendistro-alerting/opendistro-alerting-1.8.0.0.zip

echo '6- Config Kibana parameters'
echo 'server.host: 0.0.0.0' >> config/kibana.yml
echo 'elasticsearch.hosts: ["http://localhost:9200"]' >> config/kibana.yml
echo '.... done'


echo '7- First run .... port 5601 should be opened on nsg '
cd bin
./kibana


echo '*******************************************************************************************'
echo ' CAP GEMINI '
echo '**************************************   All rights reserved by Capgemini. Copyright © 2020'

