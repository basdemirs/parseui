#!/bin/bash

mkdir _postgres
cd _postgres
#IMAGE_TAG=centos7-11.3-2.4.0
#IMAGE_TAG=centos7-10.8-2.4.0
IMAGE_TAG=centos7-10.4-2.0.0

docker volume create --driver local --name=pgvolume
docker volume create --driver local --name=pgsshd
docker volume create --driver local --name=pgconf
docker volume create --driver local --name=pgwal
docker volume create --driver local --name=pgrecover
docker volume create --driver local --name=pga4volume
docker volume create --driver local --name=pga4certs
docker volume create --driver local --name=pga4httpd

docker network create --driver bridge pgnetwork

cat << EOF > pg-env.list
PG_MODE=primary
PG_PRIMARY_USER=postgres
PG_PRIMARY_PASSWORD=password
PG_DATABASE=cdrdb
PG_USER=cdruser
PG_PASSWORD=password
PG_ROOT_PASSWORD=rootpass
PG_PRIMARY_PORT=5432
EOF

cat << EOF > pgadmin-env.list
PGADMIN_SETUP_EMAIL=aa@aa.com
PGADMIN_SETUP_PASSWORD=password
SERVER_PORT=5050
EOF

docker run --publish 5432:5432 \
  --volume=pgvolume:/pgdata \
  --volume=pgsshd:/sshd \
  --volume=pgconf:/pgconf \
  --volume=pgwal:/pgwal \
  --volume=pgrecover:/recover \
  --volume=backrestrepo:/backrestrepo \
  --env-file=pg-env.list \
  --name="postgres" \
  --hostname="postgres" \
  --network="pgnetwork" \
  --detach \
crunchydata/crunchy-postgres:${IMAGE_TAG} 

docker run --publish 5050:5050 \
  --volume=pga4volume:/var/lib/pgadmin \
  --volume=pga4certs:/certs \
  --volume=pga4httpd:/run/httpd \
  --env-file=pgadmin-env.list \
  --name="pgadmin4" \
  --hostname="pgadmin4" \
  --network="pgnetwork" \
  --detach \
crunchydata/crunchy-pgadmin4:${IMAGE_TAG} 
