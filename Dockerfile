FROM jupyterhub/jupyterhub:latest

MAINTAINER Tomas Tinoco De Rubira <ttinoco5687@gmail.com>

# General
RUN apt-get update -y
RUN apt-get install -y build-essential
RUN apt-get install -y autoconf libtool 
RUN apt-get install -y libblas-dev liblapack-dev gfortran

# Python
ADD common_requirements.txt .
RUN pip install -r common_requirements.txt
RUN pip install notebook matplotlib

# Ipopt and Mumps
WORKDIR /packages
ADD https://www.coin-or.org/download/source/Ipopt/Ipopt-3.12.7.tgz Ipopt-3.12.7.tgz
RUN gunzip Ipopt-3.12.7.tgz
RUN tar xvf Ipopt-3.12.7.tar
WORKDIR Ipopt-3.12.7
WORKDIR ThirdParty/Mumps
RUN ./get.Mumps
WORKDIR ../../
RUN ./configure
RUN make 
RUN make test
RUN make install

# PFNET
WORKDIR /packages
RUN git clone -b master https://github.com/ttinoco/PFNET.git  #
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
COPY optalg_setup.cfg setup.cfg
RUN pip install -r requirements.txt
RUN python setup.py build_ext --inplace --with "mumps ipopt"
RUN nosetests -s -v
RUN python setup.py install --with "mumps ipopt"

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

