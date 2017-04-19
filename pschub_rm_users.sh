#!/bin/bash

name=$1

if [[ -n "$name" ]]; then
    filename=$(basename $name)
    docker cp $name pschub:/tmp/$filename
    docker exec pschub bash /scripts/rm_users.sh /tmp/$filename
    docker exec pschub rm /tmp/$filename
else
    echo "argument error"
fi
