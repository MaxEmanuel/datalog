FROM ubuntu:16.04
MAINTAINER Henrik Mühe <henrik.muehe@gmail.com>

RUN apt-get update

# Install node and some tools
RUN apt-get install -y git nodejs npm tmux unzip wget
RUN ln -s /usr/bin/nodejs /usr/bin/node

# Install swi-pl
RUN cd /tmp ; wget http://www.swi-prolog.org/download/stable/src/pl-6.6.6.tar.gz ; tar zxf pl-6.6.6.tar.gz
RUN cd /tmp/pl-6.6.6 ; ./configure --prefix=/opt/swi-prolog && make && make install

# Install des
RUN cd /tmp ; wget https://downloads.sourceforge.net/project/des/des/des5.0.1/DES5.0.1SWI.zip
RUN cd /opt ; unzip /tmp/DES5.0.1SWI.zip
RUN cd /opt/des ; echo '/opt/swi-prolog/bin/swipl -g "ensure_loaded(des)"' >> des ; chmod 755 des

# Install src and modules
ADD . /src
RUN cd /src ; make install all

# Run
EXPOSE 8080
CMD ["/src/startup.sh"]
