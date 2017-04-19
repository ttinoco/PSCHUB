FROM jupyterhub/jupyterhub:latest

MAINTAINER Tomas Tinoco De Rubira <ttinoco5687@gmail.com>

# General
RUN apt-get update -y
RUN apt-get install -y build-essential
RUN apt-get install -y autoconf libtool 
RUN pip install notebook matplotlib

# PFNET
WORKDIR /packages
RUN git clone -b master https://github.com/ttinoco/PFNET.git #
WORKDIR PFNET
RUN ./autogen.sh
RUN ./configure
RUN make
RUN make check
RUN make install
WORKDIR python
RUN pip install -r requirements.txt
RUN python setup.py build_ext --inplace
RUN nosetests -s -v
RUN python setup.py install

# OPTALG
WORKDIR /packages
RUN git clone -b master https://github.com/ttinoco/OPTALG.git
WORKDIR OPTALG
RUN pip install -r requirements.txt
RUN python setup.py build_ext --inplace
RUN nosetests -s -v
RUN python setup.py install

# GRIDOPT
WORKDIR /packages
RUN git clone -b master https://github.com/ttinoco/GRIDOPT.git #
WORKDIR GRIDOPT
RUN nosetests -s -v
RUN python setup.py install

# Configuration
WORKDIR /srv/jupyterhub
ADD jupyterhub_config.py /srv/jupyterhub/jupyterhub_config.py
ADD cull_idle_servers.py /srv/jupyterhub/cull_idle_servers.py

# Notebooks
COPY notebooks /notebooks

# User management
RUN mkdir /scripts
ADD ./users/add_users.sh /scripts
ADD ./users/rm_users.sh /scripts

