#!/bin/bash

hostname=`hostname`

psql -h postgres -U irods ICAT -c "UPDATE r_resc_main SET resc_net='$hostname' WHERE resc_id=9101"

/var/lib/irods/packaging/./setup_irods.sh < setup_answers

tail -f /var/lib/irods/iRODS/server/log/rodsLog.*
