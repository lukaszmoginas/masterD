# masterD


## Postgresql
### Default flow:

* > vagrant up
* > vagrant ssh
* > cd database/database/postgresql
* > docker-compose up -d
* > ssh project@10.24.1.17 
  >
  > p: project
* > cd src/
* > sudo chmod +x seedDB.sh
* > ./seedDB.sh
  >
  >It will add seed you DB with fake data



### Connection to DBMS:

From vms:
``` docker exec -it postgresql_postgres_1 psql -U postgres ```
    
From host PC (1):
``` psql -h 10.24.1.17 -p 5432 -U postgres ```
>  1 - (required postgresql client) ```sudo apt-get install postgresql-client```