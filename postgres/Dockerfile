FROM postgres

ADD password.txt /docker-entrypoint-initdb.d/
ADD setup_irods_db.sh /docker-entrypoint-initdb.d/
RUN chmod u+x /docker-entrypoint-initdb.d/setup_irods_db.sh
