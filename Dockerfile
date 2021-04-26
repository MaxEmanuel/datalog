FROM ubuntu:20.04
MAINTAINER Maximilian E. Schüle <m.schuele@tum.de>

ENV DEBIAN_FRONTEND noninteractive
# Install node and some tools
RUN apt-get update && apt-get install -y git nodejs npm tmux unzip wget htop g++ make basex openjdk-11-jdk libjing-java libxml-commons-resolver1.1-java libjline-java

# Install swi-pl
RUN apt-get update -qq \
    && apt-get install -y \
       software-properties-common \
       swi-prolog \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install des
RUN cd /tmp && wget https://downloads.sourceforge.net/project/des/des/des5.0.1/DES5.0.1SWI.zip  && \
        cd /opt && unzip /tmp/DES5.0.1SWI.zip && \
        cd /opt/des && echo 'swipl -g "ensure_loaded(des)"' >> des && chmod 755 des

# Install src and modules
COPY ./src /src/src/
COPY ./public /src/public/
COPY ./views /src/views/
COPY bower.json config.json Makefile package.json server.js startup.sh /src/
RUN cd /src && make install all

# Run rest as non root user
RUN useradd -ms /bin/bash dockeruser
USER dockeruser
WORKDIR /home/dockeruser

# Run
EXPOSE 8080
ENV TERM=xterm
CMD ["/src/startup.sh"]
