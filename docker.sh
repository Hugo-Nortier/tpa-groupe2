#! /bin/sh
CIP=`hostname -I | awk '{print $1}'`;
export CIP;
docker container rm -f $(docker container ls -qa) 
docker compose -f docker/docker-compose.yml up