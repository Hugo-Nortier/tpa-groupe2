#! /bin/sh

# TODO utilisateur: modifiez la variable d'environnements MONPATH!!!
MONIP=`hostname -I | awk '{print $1}'`;
export MONIP;
MONPATH=/mnt/d/TPA/2Data/Groupe_TPT_2/
export MONPATH;
# run l'écriture dans les BD mongo et cassandra
etl/mongo_cassandra_run.sh;
# copie les csv dans le container hive
docker cp ${MONPATH}/M2_DMA_Immatriculations/Immatriculations.csv $(docker ps -aqf "name=hive-server"):/Immatriculations.csv;
docker cp ${MONPATH}/M2_DMA_Catalogue/Catalogue_new.csv $(docker ps -aqf "name=hive-server"):/Catalogue_new.csv;
# run l'écriture dans hdfs
etl/hdfs_run.sh;