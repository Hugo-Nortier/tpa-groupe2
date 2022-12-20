# Création et Initialisation du Data Lake - TPA Groupe 2
## _MIAGE M2 MBDS - 2022/2023_

### Prérequis

- avoir installé docker
- avoir installé java

### A faire au préalable

**Si vous possédez docker v3:**
- éditez docker.sh et remplacez "docker compose" par "docker-compose"

**Dans tous les cas**
- éditez etl.sh et remplacez la valeur de MONPATH par la vôtre en respectant cet architecture:
```
MONPATH/
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

### Vérifications
**hive**
```sh
docker-compose exec hive-server bash
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