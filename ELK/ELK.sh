#!/bin/bash

docker network create elk-net

#Elasticsearch
#docker pull docker.elastic.co/elasticsearch/elasticsearch:7.16.2
docker run -d -it --name "elasticsearch" --hostname "elasticsearch" \
--network "elk-net" -p 9200:9200 -p 9300:9300 \
-v "elasticsearch_config:/usr/share/elasticsearch/config" \
-v "elasticsearch_data:/usr/share/elasticsearch/data" \
-e "discovery.type=single-node" \
-e "ELASTIC_PASSWORD=elastic" \
#-e "ELASTIC_PASSWORD_FILE=/run/secrets/bootstrapPassword.txt" \
#-e "bootstrap.memory_lock=true" --ulimit memlock=-1:-1 \
#-e "ES_JAVA_OPTS=-Xms512m -Xmx512m" \
docker.elastic.co/elasticsearch/elasticsearch:7.16.2

#Kibana
#docker pull docker.elastic.co/kibana/kibana:7.16.2
docker run -d -it --name "kibana" --hostname "kibana" \
--network "elk-net" -p 5601:5601 \
-v "kibana_config:/usr/share/kibana/config" \
-v "kibana_data:/usr/share/kibana/data" \
-e "ELASTICSEARCH_HOSTS=http://elasticsearch:9200" \
docker.elastic.co/kibana/kibana:7.16.2

#*******************

#Logstash
#docker pull docker.elastic.co/logstash/logstash:7.16.2

docker run -d -it --name "logstash" --hostname "logstash" \
--network "elk-net" -p 5000:5000 \
-v "logstash_config:/usr/share/logstash/config" \
-v "logstash_pipeline:/usr/share/logstash/pipeline" \
-v "logstash_logs:/usr/share/logstash/logs" \
#-e "PIPELINE_WORKERS=" \
#-e "LOG_LEVEL=" \
#-e "MONITORING_ENABLED=true" \
#-e "monitoring.elasticsearch.hosts=http://elasticsearch:9200" \
docker.elastic.co/logstash/logstash:7.16.2
