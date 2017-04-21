#!/bin/bash

if [ $# -lt 1 ]
then
    echo "Usage : $0 userfile"
    exit
fi

if [ $(id -u) -eq 0 ]; then
    
    while IFS=, read username password; do
	
	rm -rf /data/workspace-$username

	if egrep "^$username" /etc/passwd >/dev/null;  then

	    if userdel -rf $username  >/dev/null; then
   		echo "User '$username' has been deleted!"
	    else
		echo "Failed to delete user '$username'!"
	    fi
	else
  	    echo "User '$username' does not exist!"
	fi
	
    done < <(grep "" "$@")

else
    echo "Only root may add a user to the system"
    exit
fi
