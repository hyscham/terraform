echo '*********************** Centos 7.5 *************************'
echo 'Deploying ElasticSearch and Kibana on Cloud VM..............'
echo '**************************** By h.ennakouch@gmail.com ******'



echo '*********************  Create efk user  ********************'
useradd -m efk



echo '************************************************************'
echo '********************* JDK configuration ********************'
echo '************************************************************'


echo '1- Installing OpenJdk 1.8 ...'
yum install java-1.8.0-openjdk-devel unzip -y
echo '.....done'

echo '************************************************************'
echo '********** Elastic Search 7.7.0 OSS Install ****************'
echo '************************************************************'

echo '2- Create a working dir'
mkdir /home/efk/deploy
echo '.... done'

echo 'move to create dir'
cd /home/efk/deploy


echo '3- Download ElasticSearch 7.7.0 OSS'
curl -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-7.7.0-linux-x86_64.tar.gz
echo '.... done'

echo '4- Untar downloaded package....'
tar -xzf elasticsearch-oss-7.7.0-linux-x86_64.tar.gz
mv elasticsearch*/ elasticsearch


cd elasticsearch

sudo ln -s /usr/lib/jvm/java-1.8.0/lib/tools.jar lib/


echo '5- Download and Install OpenDistro JOB SCHEDULER plugin ...'
bin/elasticsearch-plugin install --batch https://d3g5vo6xdbdb9a.cloudfront.net/downloads/elasticsearch-plugins/opendistro-job-scheduler/opendistro-job-scheduler-1.8.0.0.zip
echo '..... Done'

echo '6- Download and Install OpenDistro Alerting plugin for ElasticSearch ... '
bin/elasticsearch-plugin install --batch https://d3g5vo6xdbdb9a.cloudfront.net/downloads/elasticsearch-plugins/opendistro-alerting/opendistro_alerting-1.8.0.0.zip
echo '... Done.'


echo '6- Configuring network-host parameter for elasticsearch '
echo 'network.host: 0.0.0.0' >> config/elasticsearch.yml
echo 'network.bind_host: 0.0.0.0' >> config/elasticsearch.yml
echo 'node.master: true' >> config/elasticsearch.yml
echo 'node.data: true' >> config/elasticsearch.yml
echo 'transport.host: localhost' >> config/elasticsearch.yml

echo '... Done'

echo '7- First run .... port 9200 should be opened on nsg '
chown -R efk:efk /home/efk/deploy/elasticsearch




echo '*****************************************************************'
echo '**************** Kibana 7.7.0 OSS install  **********************'
echo '*****************************************************************'

echo '1- Download Kibana 7.7.0 OSS package'
cd /home/efk/deploy
curl -O https://artifacts.elastic.co/downloads/kibana/kibana-oss-7.7.0-linux-x86_64.tar.gz
echo '... done'

echo '2- untar Kibana downloaded package'
tar -xzf kibana-oss-7.7.0-linux-x86_64.tar.gz
echo '... done'

echo '3- Rename Kibana folder'
mv kibana*/ kibana

echo '4- Move to kibana Folder'
cd kibana

echo '5- Install OpenDistro Alerting plugin for Kibana'
bin/kibana-plugin install --batch https://d3g5vo6xdbdb9a.cloudfront.net/downloads/kibana-plugins/opendistro-alerting/opendistro-alerting-1.8.0.0.zip

echo '6- Config Kibana parameters'
echo 'server.host: 0.0.0.0' >> config/kibana.yml
echo 'elasticsearch.hosts: ["http://localhost:9200"]' >> config/kibana.yml
echo '.... done'


echo '7- First run .... port 5601 should be opened on nsg '
chown -R efk:efk /home/efk/deploy/kibana


echo '*************************** Start Elastic ***************************************'
cd /home/efk/deploy/elasticsearch/bin
su efk -c "./elasticsearch &&"
echo '*************************** Start Kibana ****************************************'
cd /home/efk/deploy/kibana/bin
su efk -c "./kibana"


echo '**********************************`Server_IP`***********************************************'
echo '********************************************************************************************'
ip a|grep inet
echo '********************************************************************************************'
echo '********************************************************************************************'



echo '**********************************`Server_IP`***********************************************'
echo ' CAP GEMINI '
echo '**************************************   All rights reserved by Capgemini. Copyright © 2020'
