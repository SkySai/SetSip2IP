#!/bin/bash

auth="admin:admin"
PROGNAME=$(basename "$0")
if [ "$#" -eq 1 ]; then
    ipFile=$1
elif [ "$#" -eq 2 ]; then
    password=$1
    ipFile=$2
elif [ "$#" -eq 3 ]; then
    ipFile=$3
    password=$2
    registrarIP=$1
    
else
    echo "USAGE: batchRun [auth] ipFile"
    echo "auth: specify username and password when non default (admin:admin) include the colon to separate the username from the password"
    echo "ipFile: specify filename with list of IPs"
    exit 1
fi
sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba' $ipFile > temp
while IFS="" read -r line || [ -n "$line" ]
do
 ip=$line
./setSip2IP.sh ${registrarIP} ${password} ${ip}

 done <"temp"
rm temp
