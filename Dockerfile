FROM jupyterhub/jupyterhub:latest

MAINTAINER Tomas Tinoco De Rubira <ttinoco5687@gmail.com>

# General
RUN apt-get update -y
RUN apt-get install -y build-essential
RUN apt-get install -y libblas-dev liblapack-dev gfortran

# Python
ADD common_requirements.txt .
RUN pip install -r common_requirements.txt
RUN pip install notebook matplotlib
RUN pip install pfnet optalg --verbose
RUN pip install gridopt --verbose

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
ADD ./users/sample.csv /tmp
RUN bash /scripts/add_users.sh /tmp/sample.csv
