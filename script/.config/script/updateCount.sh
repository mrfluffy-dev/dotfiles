#!/bin/bash

sleep 30
checkupdates > out.log 2>/dev/null

if [ $? -eq 0 ]
then 
	echo $(checkupdates | wc -l) updates
	exit 0
elif [ $? -eq 1 ]
then
	echo "0 updates" 
	exit 0
else
	echo "0 updates"
	exit 1
fi
