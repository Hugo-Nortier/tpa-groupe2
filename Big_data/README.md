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
└── M2_DMA_Marketing
    └── Marketing.csv
```

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
export MONPATH=/mnt/c/Users/dofla/Desktop/tpa-groupe2/csv/
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
etl/hdfs_run.sh;
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
docker exec -it mongo mongosh
```
**cassandra**
```sh
docker run --rm -it --network cassandra nuvo/docker-cqlsh cqlsh cassandra 9042 --cqlversion='3.4.0'
```

### Effectuer des rêquetes vers le data lake
Vous poucez utiliser prestoDB pour effectuer des rêquetes SQL vers Hive.  
Pour cela, il faudra utiliser le `presto.jar` se trouvant à la racine.  
```sh
presto.jar --server localhost:8080 --catalog hive --schema default
presto> select * from catalogue;
```