FROM ubuntu:16.04

MAINTAINER Erik van den Bergh, Earlham Institute, Norwich

# install reqs
RUN apt update && apt install -y \
                   wget \
		   sudo \
		   lsof \
		   lsb-release \
		   apt-transport-https \
		   make \
		   binutils \
		   gcc \
		   g++ \
		   libssl-dev \
		   libpam0g-dev \
		   git \
		   unixodbc-dev \
		   libkrb5-dev


RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add -
RUN echo "deb [arch=amd64] https://packages.irods.org/apt/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/renci-irods.list

RUN apt update && apt install -y irods-externals-*

WORKDIR /tmp

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN git clone 'https://github.com/irods/irods'
WORKDIR /tmp/irods
RUN git checkout 4-2-stable

RUN mkdir build
WORKDIR /tmp/irods/build

RUN /opt/irods-externals/cmake3.5.2-0/bin/cmake ../
RUN make install

# clean 
RUN apt clean autoclean && apt autoremove -y
RUN rm -rf /var/lib/cache /var/lib/log /var/lib/apt/lists/*
RUN rm -rf *.deb

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

# expose iRODS port
EXPOSE 1247
