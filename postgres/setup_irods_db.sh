#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER irods WITH PASSWORD 'testpassword';
    CREATE DATABASE "ICAT";
    GRANT ALL PRIVILEGES ON DATABASE "ICAT" TO irods;
EOSQL
