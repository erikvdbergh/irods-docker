#!/bin/bash

/etc/init.d/postgresql start

su postgres -c 'psql -c "CREATE USER irods WITH PASSWORD '\''testpassword'\'';"'
su postgres -c 'psql -c "CREATE DATABASE \"ICAT\";"'
su postgres -c 'psql -c "GRANT ALL PRIVILEGES ON DATABASE \"ICAT\" TO irods;"'

/var/lib/irods/packaging/./setup_irods.sh < setup_answers
