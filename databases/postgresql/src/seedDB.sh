#!/bin/bash
if [ -d  data/restore.sql ]; then
  createdb -h 10.24.1.17 -p 5432 -U postgres prod
  psql -h 10.24.1.17 -p 5432 -U postgres prod < data/restore.sql
else
  echo the directory does not exist!
fi
