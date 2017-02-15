#!/bin/bash
set -e

password=`cat /docker-entrypoint-initdb.d/password.txt`

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER irods WITH PASSWORD '$password';
    CREATE DATABASE "ICAT";
    GRANT ALL PRIVILEGES ON DATABASE "ICAT" TO irods;
EOSQL
