# PSCHub: Power Systems Computing Hub

A JupyterHub docker container for power systems computing.

## Requirements

* docker engine

## Available Packages

Inside the PSCHub docker container, the following packages are available:

* Scipy, Numpy
* PFNET, OPTALG, GRIDOPT 

## Build and Deploy Instructions

The following shell scripts are available for building and deploying PSCHub:

* `pschub_build.sh` to build PSCHub docker image and create PSCHub docker container
* `pschub_start.sh` to start PSCHub server inside the docker container (available at http://localhost)
* `pschub_stop.sh` to stop PSCHub server (or CTRL-C)
* `pschub_destroy.sh` to destroy the PSCHub docker container.

## Volumes

A docker volume `pschub-data` needs to be created to make user worspaces persistent. This can be done with the command

```
docker volume create pschub-data
```

This volume is mounted to the directory `/data` inside the PSCHub docker container when the script ``pschub_build.sh`` is executed.

## Notebooks

The welcome notebook is the file `notebooks/Welcome.ipynb` in this reposiory. Each user gets a clean copy of the directory `notebooks/examples` each time they start a session. The network files for the examples are in the directory `notebooks/cases`.

## Workspace

Each user gets a `workspace` directory where they can create and save notebooks. This directory is backed up in `/data/workspace-username` inside the PSCHub container and hence also in the persistent docker volume `pschub-data`.

## User Management

Adding and removing users of PSCHub can be done using the shell scripts

* `pschub_add_users.sh`
* `pschub_rm_users.sh`.

These scripts take as argument a csv file with username,password pairs on each line. Removing users also deletes their backup files in the docker volume `pschub-data`. A sample users file is available in `users/sample.csv`.

## Debugging

The script `pschub_connect.sh` can be used to open an interactive bash session inside the running PSCHub docker container.
