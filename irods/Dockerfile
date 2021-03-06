FROM ubuntu:18.04

MAINTAINER Erik van den Bergh, Earlham Institute, Norwich

# install reqs
RUN apt update && apt install -y \
                    wget \
	                  apt-transport-https \
		                libxml2 \
                    lsb-release \
                    gnupg


RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add -
RUN echo "deb [arch=amd64] https://packages.irods.org/apt/ xenial main" > /etc/apt/sources.list.d/renci-irods.list

RUN apt update && apt install -y irods-server irods-database-plugin-postgres

# clean 
#RUN rm -rf /var/lib/cache /var/lib/log /var/lib/apt/lists/*
#RUN rm -rf *.deb

# create volume to hold actual data
VOLUME /var/lib/irods/Vault
VOLUME /etc/irods

# copy and run setup script; it ends with "tail -f" of the irods log as to keep
# the docker container running
COPY unattended_setup.json /tmp/unattended_setup.json

RUN echo  '#!/bin/bash \n\
          python /var/lib/irods/scripts/setup_irods.py --json_configuration_file /tmp/unattended_setup.json && \n\
          tail -f /var/lib/irods/log/rodsLog*             \n\
                                                          \n\
          function finish {                               \n\
            service irods-server stop                     \n\
          }                                               \n\
          trap finish EXIT SIGINT SIGHUP SIGQUIT SIGTERM  \n\
          ' > /usr/bin/entry
RUN chmod u+x /usr/bin/entry

CMD entry

# expose iRODS port
EXPOSE 1247 20000-20199
