# Création et Initialisation du Data Lake - TPA Groupe 2
## _MIAGE M2 MBDS - 2022/2023_

### Prérequis

- avoir installé docker
- avoir installé java

### A faire au préalable

**Si vous possédez docker v3:**
- éditez docker.sh et remplacez "docker compose" par "docker-compose"

**Dans tous les cas**
- éditez etl.sh et remplacez la valeur de MONPATH (qui correspond à la racine de l’emplacement des fichiers CSV) par la vôtre en respectant cette architecture:
```
MONPATH
├── M2_DMA_Catalogue
│   └── Catalogue.csv
├── M2_DMA_Clients_10
│   └── Clients_9.csv
├── M2_DMA_Clients_2
│   └── Clients_1.csv
├── M2_DMA_Immatriculations
│   └── Immatriculations.csv
	└── Immatriculations_predites.csv
└── M2_DMA_Marketing
    └── Marketing.csv
```
- téléchargez le fichier [Immatriculations_predites.csv](https://drive.google.com/file/d/1iOEKdQ7ZKYDIvZ9jVB3Ojuu2FyTWhBU9/view?usp=sharing) 
- placez le fichier suscité dans le dossier M2_DMA_Immatriculations.
- ROOT_PATH=/le/chemin/absolu/vers/tpa-groupe2/Big_data/etl

### Lancement

Faites dans 2 terminaux différents:
```sh
sh docker.sh
```
```sh
sh etl.sh
```

La première ligne de docker.sh supprime les containers qui seraient eventuellement déjà 'in use', S'il n'y en a pas, un warning s'affichera, n'en tenez pas compte.

le docker.sh effectue ces commandes:
```sh
export CIP=`hostname -I | awk '{print $1}'`;
docker network create cassandra
docker container rm -f $(docker container ls -qa) 
docker compose -f docker/docker-compose.yml up
```
le etl.sh effectue ces commandes:
```sh
# TODO utilisateur: modifiez la variable d'environnements MONPATH!!!
export MONIP=`hostname -I | awk '{print $1}'`;
export MONPATH=/mnt/d/TPA/2Data/Groupe_TPT_2/
# run l'écriture dans les BD mongo et cassandra
java -Dtalend.component.manager.m2.repository=$ROOT_PATH/../lib -Xms256M -Xmx1024M -cp .:$ROOT_PATH:$ROOT_PATH/./lib/routines.jar:$ROOT_PATH/./lib/log4j-jcl-2.12.1.jar:$ROOT_PATH/./lib/log4j-slf4j-impl-2.12.1.jar:$ROOT_PATH/./lib/log4j-api-2.12.1.jar:$ROOT_PATH/./lib/log4j-core-2.12.1.jar:$ROOT_PATH/./lib/metrics-core-3.1.2.jar:$ROOT_PATH/./lib/commons-beanutils-1.8.3.jar:$ROOT_PATH/./lib/jaxen-1.1.6.jar:$ROOT_PATH/./lib/xom-1.2.7.jar:$ROOT_PATH/./lib/talend-cassandra-1.2.jar:$ROOT_PATH/./lib/slf4j-api-1.7.25.jar:$ROOT_PATH/./lib/dom4j-2.1.1.jar:$ROOT_PATH/./lib/cassandra-driver-core-3.0.0-shaded.jar:$ROOT_PATH/./lib/commons-collections-3.2.2.jar:$ROOT_PATH/./lib/commons-lang-2.6.jar:$ROOT_PATH/./lib/mongo-java-driver-3.12.0.jar:$ROOT_PATH/./lib/ezmorph-1.0.6.jar:$ROOT_PATH/./lib/json-lib-2.4.5-talend.jar:$ROOT_PATH/./lib/talendcsv.jar:$ROOT_PATH/./lib/commons-logging-1.1.1.jar:$ROOT_PATH/./lib/crypto-utils.jar:$ROOT_PATH/./lib/talend_file_enhanced_20070724.jar:$ROOT_PATH/mongo_cassandra_0_5.jar: tpa_groupe2.mongo_cassandra_0_5.mongo_cassandra  --context=Default "$@"
# copie les csv dans hdfs
docker cp ${MONPATH}M2_DMA_Immatriculations/Immatriculations.csv $(docker ps -aqf "name=hive-server"):/Immatriculations.csv;
docker cp ${MONPATH}M2_DMA_Immatriculations/Immatriculations_predites.csv $(docker ps -aqf "name=hive-server"):/Immatriculations_predites.csv;
docker cp ${MONPATH}M2_DMA_Catalogue/Catalogue_new.csv $(docker ps -aqf "name=hive-server"):/Catalogue_new.csv;
docker cp ${MONPATH}M2_DMA_Clients_2/Clients_1_new.csv $(docker ps -aqf "name=hive-server"):/Clients_1_new.csv;
docker cp ${MONPATH}M2_DMA_Clients_10/Clients_9_new.csv $(docker ps -aqf "name=hive-server"):/Clients_9_new.csv;
docker cp ${MONPATH}M2_DMA_Marketing/Marketing_new.csv $(docker ps -aqf "name=hive-server"):/Marketing_new.csv;
# run l'écriture dans hive
java -Dtalend.component.manager.m2.repository=$ROOT_PATH/../lib -Xms256M -Xmx1024M -cp .:$ROOT_PATH:$ROOT_PATH/lib/routines.jar:$ROOT_PATH/lib/log4j-jcl-2.12.1.jar:$ROOT_PATH/lib/log4j-slf4j-impl-2.12.1.jar:$ROOT_PATH/lib/log4j-api-2.12.1.jar:$ROOT_PATH/lib/log4j-core-2.12.1.jar:$ROOT_PATH/lib/log4j-1.2-api-2.12.1.jar:$ROOT_PATH/lib/commons-collections-3.2.2.jar:$ROOT_PATH/lib/commons-lang-2.6.jar:$ROOT_PATH/lib/commons-logging-1.1.3.jar:$ROOT_PATH/lib/commons-codec-1.4.jar:$ROOT_PATH/lib/hadoop-mapreduce-client-core-2.8.3-amzn-1.jar:$ROOT_PATH/lib/libfb303-0.9.3.jar:$ROOT_PATH/lib/jersey-core-1.9.jar:$ROOT_PATH/lib/jetty-util-6.1.26-emr.jar:$ROOT_PATH/lib/hive-serde-2.3.3-amzn-0.jar:$ROOT_PATH/lib/libthrift-0.9.3.jar:$ROOT_PATH/lib/slf4j-api-1.7.25.jar:$ROOT_PATH/lib/datanucleus-api-jdo-4.2.4.jar:$ROOT_PATH/lib/curator-client-2.7.1.jar:$ROOT_PATH/lib/httpclient-4.5.5.jar:$ROOT_PATH/lib/datanucleus-core-4.1.17.jar:$ROOT_PATH/lib/hive-service-rpc-2.3.3-amzn-0.jar:$ROOT_PATH/lib/jersey-client-1.9.jar:$ROOT_PATH/lib/hadoop-mapreduce-client-common-2.8.3-amzn-1.jar:$ROOT_PATH/lib/zookeeper-3.4.12.jar:$ROOT_PATH/lib/servlet-api-2.5.jar:$ROOT_PATH/lib/hadoop-hdfs-client-2.8.3-amzn-1.jar:$ROOT_PATH/lib/emr-metrics-client-2.1.0.jar:$ROOT_PATH/lib/commons-cli-1.2.jar:$ROOT_PATH/lib/hadoop-hdfs-2.8.3-amzn-1.jar:$ROOT_PATH/lib/hive-service-2.3.3-amzn-0.jar:$ROOT_PATH/lib/jdo-api-3.0.1.jar:$ROOT_PATH/lib/curator-framework-2.7.1.jar:$ROOT_PATH/lib/avro-1.7.7.jar:$ROOT_PATH/lib/hive-cli-2.3.3-amzn-0.jar:$ROOT_PATH/lib/hadoop-yarn-api-2.8.3-amzn-1.jar:$ROOT_PATH/lib/commons-httpclient-3.0.1.jar:$ROOT_PATH/lib/talendcsv.jar:$ROOT_PATH/lib/datanucleus-rdbms-4.1.19.jar:$ROOT_PATH/lib/hadoop-yarn-client-2.8.3-amzn-1.jar:$ROOT_PATH/lib/hive-common-2.3.3-amzn-0.jar:$ROOT_PATH/lib/hadoop-common-2.8.3-amzn-1.jar:$ROOT_PATH/lib/jackson-xc-1.9.13.jar:$ROOT_PATH/lib/jackson-mapper-asl-1.9.14-TALEND.jar:$ROOT_PATH/lib/derby-10.12.1.1.jar:$ROOT_PATH/lib/hive-metastore-2.3.3-amzn-0.jar:$ROOT_PATH/lib/hadoop-auth-2.8.3-amzn-1.jar:$ROOT_PATH/lib/commons-configuration-1.6.jar:$ROOT_PATH/lib/antlr-runtime-3.4.jar:$ROOT_PATH/lib/commons-lang3-3.5.jar:$ROOT_PATH/lib/hadoop-mapreduce-client-jobclient-2.8.3-amzn-1.jar:$ROOT_PATH/lib/hive-jdbc-2.3.3-amzn-0.jar:$ROOT_PATH/lib/commons-io-2.4.jar:$ROOT_PATH/lib/gson-2.2.4.jar:$ROOT_PATH/lib/hive-beeline-2.3.3-amzn-0.jar:$ROOT_PATH/lib/httpcore-4.4.9.jar:$ROOT_PATH/lib/dom4j-2.1.1.jar:$ROOT_PATH/lib/hadoop-yarn-common-2.8.3-amzn-1.jar:$ROOT_PATH/lib/htrace-core4-4.0.1-incubating.jar:$ROOT_PATH/lib/jackson-core-asl-1.9.14-TALEND.jar:$ROOT_PATH/lib/guava-14.0.1.jar:$ROOT_PATH/lib/crypto-utils.jar:$ROOT_PATH/lib/hive-exec-2.3.3-amzn-0.jar:$ROOT_PATH/lib/talend_file_enhanced_20070724.jar:$ROOT_PATH/lib/jackson-jaxrs-1.9.13.jar:$ROOT_PATH/lib/protobuf-java-2.5.0.jar:$ROOT_PATH/hive_0_2.jar: tpa_groupe2.hive_0_2.hive  --context=Default "$@"
```

### Vérifications

Pour accéder aux bases de données, se placer dnas le dossier "docker" et faire :

**hive**
```sh
docker compose exec hive-server bash
/opt/hive/bin/beeline -u jdbc:hive2://localhost:10000
```
**mongo**
```sh
docker exec -it mongodb mongosh
use tpa
db.clients.find()
```
**cassandra**
```sh
docker run --rm -it --network cassandra nuvo/docker-cqlsh cqlsh cassandra 9042 --cqlversion='3.4.0'
select * from tpa.clients;
```

### Effectuer des rêquetes vers le data lake
Vous poucez utiliser prestoDB pour effectuer des rêquetes SQL vers Hive.  
Pour cela, il faudra utiliser le `presto.jar` se trouvant à la racine.  
```sh
java -jar presto.jar --server localhost:8080 --catalog hive --schema default
presto> select * from catalogue;
```