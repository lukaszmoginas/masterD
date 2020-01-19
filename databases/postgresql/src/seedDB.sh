#!/bin/bash

# update privileges for mock data
cd /home/project/src || exit
sudo chmod 0777 -R data/

# add psql client to have ability to connect to the DBMS
sudo apt-get install wget ca-certificates
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/lsb_release -cs-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
sudo apt-get update -y -q
sudo apt-get install postgresql-client postgresql-contrib -y -q
sudo service postgresql restart

#CREATE EXTENSION pg_stat_statements;

FILE=/home/project/src/data/restore.sql

if [ -f "$FILE"  ]; then
  createdb -h 10.24.1.17 -p 5432 -U postgres prod
  psql -h 10.24.1.17 -p 5432 -U postgres prod < data/restore.sql
else
  echo the directory does not exist!
fi
