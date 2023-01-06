#! /bin/sh

# TODO utilisateur: modifiez la variable d'environnements MONPATH!!!
MONIP=`hostname -I | awk '{print $1}'`;
export MONIP;
MONPATH=/mnt/c/Users/dofla/Desktop/tpa-groupe2/csv/
export MONPATH;
# run l'écriture dans les BD mongo et cassandra
etl/mongo_cassandra_run.sh;
# copie les csv dans le container hive
docker cp ${MONPATH}/M2_DMA_Immatriculations/Immatriculations.csv $(docker ps -aqf "name=hive-server"):/Immatriculations.csv;
docker cp ${MONPATH}/M2_DMA_Immatriculations/Immatriculations_predites.csv $(docker ps -aqf "name=hive-server"):/Immatriculations_predites.csv;
docker cp ${MONPATH}/M2_DMA_Catalogue/Catalogue_new.csv $(docker ps -aqf "name=hive-server"):/Catalogue_new.csv;
docker cp ${MONPATH}/M2_DMA_Clients_2/Clients_1_new.csv $(docker ps -aqf "name=hive-server"):/Clients_1_new.csv;
docker cp ${MONPATH}/M2_DMA_Clients_10/Clients_9_new.csv $(docker ps -aqf "name=hive-server"):/Clients_9_new.csv;
docker cp ${MONPATH}/M2_DMA_Marketing/Marketing_new.csv $(docker ps -aqf "name=hive-server"):/Marketing_new.csv;

# run l'écriture dans hdfs
etl/hive_run.sh;