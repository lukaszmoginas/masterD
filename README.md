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
* > sudo chmod +x develop_init.sh
* > ./develop_init.sh
  >
  >It will add seed you DB with fake data



### Connection to DBMS:

From vms:
``` docker exec -it postgresql_postgres_1 psql -U postgres ```
    
From host PC (1):
``` psql -h 10.24.1.17 -p 5432 -U postgres ```
>  1 - (required postgresql client) ```sudo apt-get install postgresql-client```


###NOTES:

> Connect to DBMS and create extension in database; 
>
> Extension isn't installed:
>
>SELECT * 
FROM pg_available_extensions 
WHERE 
    name = 'pg_stat_statements' and 
    installed_version is not null;

>If the table is empty, create the extension:
>
>CREATE EXTENSION pg_stat_statements;
