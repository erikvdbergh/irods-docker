FROM ubuntu:16.04

MAINTAINER Erik van den Bergh, Earlham Institute, Norwich

# install basics
RUN apt update
RUN apt install -y wget git vim sudo lsof

WORKDIR /tmp

RUN wget -q http://toolkit.globus.org/ftppub/gt6/installers/repo/globus-toolkit-repo_latest_all.deb
RUN dpkg -i globus-*repo*.deb
RUN apt update

# install deps and globus
RUN apt install -y libfuse2 libjson-perl unixodbc odbc-postgresql postgresql-client super \
                   python python-psutil python-requests python-jsonschema libglobus-gssapi-gsi4 \
		   libglobus-gss-assist3 globus-proxy-utils globus-gsi-cert-utils-progs \
		   globus-simple-ca globus-gsi globus-gridftp

# clean
RUN apt clean autoclean && apt autoremove -y
RUN rm -rf /var/lib/cache /var/lib/log

# some variables to shorten following commands
ENV OSVERSION ubuntu14
ENV IRODSVERSION 4.1.10
ENV PLUGINVERSION 1.10
ENV FTPDIR ftp://ftp.renci.org/pub/irods/releases/$IRODSVERSION/$OSVERSION

# get and install irods, db plugin and globus auth
RUN wget -q $FTPDIR/irods-icat-${IRODSVERSION}-${OSVERSION}-x86_64.deb
RUN wget -q $FTPDIR/irods-database-plugin-postgres-${PLUGINVERSION}-${OSVERSION}-x86_64.deb

RUN wget -q ftp://ftp.renci.org/pub/irods/plugins/irods_auth_plugin_gsi/1.4/irods-auth-plugin-gsi-1.4-${OSVERSION}-x86_64.deb

RUN dpkg -i irods-icat-${IRODSVERSION}-${OSVERSION}-x86_64.deb
RUN dpkg -i irods-database-plugin-postgres-${PLUGINVERSION}-${OSVERSION}-x86_64.deb
RUN dpkg -i irods-auth-plugin-gsi-1.4-${OSVERSION}-x86_64.deb

# Increase the logfile rotation so we can keep following it to keep the docker container
# running. This is a hack and should be changed in 4.2, see 
# https://groups.google.com/d/topic/irod-chat/L6PpTd_5YBc/discussion and 
# https://github.com/irods/irods/issues/2730
RUN sed -i '1i $LOGFILE_INT=365;' /var/lib/irods/iRODS/scripts/perl/irodsctl.pl

# create volume to hold actual data
VOLUME /var/lib/irods/iRODS/Vault

# this is fragile; it is an input file that answers all the questions of the setup script
# there's no other way before 4.2, see https://github.com/irods/irods/issues/2790
COPY setup_answers .

# copy and run setup script; it ends with "tail -f" of the irods log as to keep
# the docker container running
COPY irods_db_setup.sh .
RUN chmod u+x irods_db_setup.sh

ENTRYPOINT ["/tmp/irods_db_setup.sh"]