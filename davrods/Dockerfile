FROM ubuntu:18.04
ARG VERSION=1.4.1

MAINTAINER Erik van den Bergh, Earlham Institute, Norwich

# install reqs
RUN apt update && apt install -y \
                    wget \
	                  apt-transport-https \
                    gnupg \
                    apache2 \
                    unzip \
                    libcurl4-openssl-dev


RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add -
RUN echo "deb [arch=amd64] https://packages.irods.org/apt/ trusty main" > /etc/apt/sources.list.d/renci-irods.list
#RUN echo "deb [arch=amd64] https://packages.irods.org/apt/ xenial main" > /etc/apt/sources.list.d/renci-irods.list

RUN apt update && apt install -y irods-runtime=4.2.1 irods-dev=4.2.1 irods-icommands=4.2.1
#RUN apt update && apt install -y irods-runtime irods-dev irods-icommands

#WORKDIR /tmp
#RUN wget -qO davrods.zip https://github.com/billyfish/eirods-dav/releases/download/$VERSION/davrods_$VERSION.zip
#RUN unzip davrods.zip

#RUN cp davrods_$VERSION/modules/mod_davrods.so /usr/lib/apache2/modules/
COPY mod_davrods.so /usr/lib/apache2/modules/
RUN echo "LoadModule davrods_module /usr/lib/apache2/modules/mod_davrods.so" > /etc/apache2/mods-available/davrods.load
COPY httpd-davrods.conf /etc/apache2/sites-available/
COPY irods.conf /etc/ld.so.conf.d
COPY irods_environment.json /etc/httpd/irods/irods_environment.json
COPY davrods_files/ /var/www/html/

RUN wget -qO /usr/bin/wait-for-it https://github.com/vishnubob/wait-for-it/raw/master/wait-for-it.sh
RUN chmod ugo+x /usr/bin/wait-for-it


RUN ldconfig
RUN a2enmod rewrite
RUN a2enmod dav
RUN a2enmod davrods
RUN a2ensite httpd-davrods

RUN echo '#!/bin/bash                                    \n\
          wait-for-it irods:1247 &&                      \n\
          /usr/sbin/apachectl start &&                   \n\
          tail -f /var/log/apache2/access.log -f /var/log/apache2/error.log \n\
                                                         \n\
          function finish {                              \n\
            service apache2 stop                         \n\
          }                                              \n\
          trap finish EXIT SIGINT SIGHUP SIGQUIT SIGTERM \n\
          ' > /usr/bin/entry
RUN chmod u+x /usr/bin/entry

CMD entry
