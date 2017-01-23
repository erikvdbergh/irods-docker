FROM ubuntu:16.04

MAINTAINER Erik van den Bergh, Earlham Institute, Norwich

RUN apt update
RUN apt install -y wget git vim sudo lsof

WORKDIR /tmp

RUN wget -q http://toolkit.globus.org/ftppub/gt6/installers/repo/globus-toolkit-repo_latest_all.deb
RUN dpkg -i globus-*repo*.deb
RUN apt update

RUN apt install -y libfuse2 libjson-perl unixodbc odbc-postgresql postgresql-client super \
                   python python-psutil python-requests python-jsonschema libglobus-gssapi-gsi4 \
		   libglobus-gss-assist3 globus-proxy-utils globus-gsi-cert-utils-progs \
		   globus-simple-ca globus-gsi globus-gridftp

RUN apt clean autoclean && apt autoremove -y
RUN rm -rf /var/lib/cache /var/lib/log

# db setup
RUN apt install -y postgresql-common postgresql-client-9.5 postgresql-9.5

ENV OSVERSION ubuntu14
ENV IRODSVERSION 4.1.10
ENV PLUGINVERSION 1.10
ENV FTPDIR ftp://ftp.renci.org/pub/irods/releases/$IRODSVERSION/$OSVERSION

RUN wget -q $FTPDIR/irods-icat-${IRODSVERSION}-${OSVERSION}-x86_64.deb
RUN wget -q $FTPDIR/irods-database-plugin-postgres-${PLUGINVERSION}-${OSVERSION}-x86_64.deb

RUN wget ftp://ftp.renci.org/pub/irods/plugins/irods_auth_plugin_gsi/1.4/irods-auth-plugin-gsi-1.4-${OSVERSION}-x86_64.deb

RUN dpkg -i irods-icat-${IRODSVERSION}-${OSVERSION}-x86_64.deb
RUN dpkg -i irods-database-plugin-postgres-${PLUGINVERSION}-${OSVERSION}-x86_64.deb
RUN dpkg -i irods-auth-plugin-gsi-1.4-${OSVERSION}-x86_64.deb

# this is fragile; it is an input file that answers all the questions of the setup script
# there's no other way ATM, see https://github.com/irods/irods/issues/2790
COPY setup_answers .
COPY irods_db_setup.sh .
RUN chmod u+x irods_db_setup.sh
RUN ./irods_db_setup.sh

VOLUME /var/lib/irods/iRODS/Vault
