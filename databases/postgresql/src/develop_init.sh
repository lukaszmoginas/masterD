#!/bin/bash

### update system ###
echo Updating system...
sudo apt-get install wget ca-certificates
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/lsb_release -cs-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
sudo apt-get update -y -q && sudo apt-get upgrade -y -q

echo System was successfully updated.
###

### update privileges for mock data ###
cd /home/project/src || exit
sudo chmod 0777 -R data/
###

### add psql client to have ability to connect to the DBMS ###
echo Adding required extensions...
sudo apt-get install postgresql-client postgresql-contrib auditd cron -y -q
echo Extensions was successfully added.

echo Restarting posgresql services...
sudo service postgresql restart
###

### create and seed database ###
echo Starting to migrate data...
FILE=/home/project/src/data/restore.sql

if [ -f "$FILE" ]; then
  createdb -h 10.24.1.17 -p 5432 -U postgres prod
  psql -h 10.24.1.17 -p 5432 -U postgres prod <data/restore.sql

  echo Data was successfully migrated.
else
  echo File or directory does not exist!
fi
###

### install required files with composer ###
echo Executing composer install...
# shellcheck disable=SC2164
cd /home/project/src/main
composer install --no-interaction
echo Done
###

### Create service ###
sudo mv service/honey.service /etc/systemd/system/
systemctl start honey
###

### create trigger ###
echo Starting Cronjob...
#sudo /etc/init.d/cron start //uncomment when it will be needed.

echo Add executable to cronjob...
(
  crontab -l 2>/dev/null
  echo "* * * * * php /home/project/src/main/index.php"
  echo "* * * * * /bin/date >> /tmp/cron_output"
  echo ""
) | crontab -

echo Executables was added to cronjob.
###
