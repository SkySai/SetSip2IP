#!/bin/bash

auth="admin:admin"

if [ "$#" -eq 1 ]; then
    ip=$1
elif [ "$#" -eq 2 ]; then
    auth=admin:$1
    ip=$2
elif [ "$#" -eq 3 ]; then
    registrarIP=$1
    auth=admin:$2
    ip=$3
else
    echo "USAGE: setSipDetails [auth] ip"
    echo "auth: specify username and password when non default (admin:admin) include the colon to separate the username from the password"
    echo "ip: specify endpoint IP address"
    exit 1
fi

# 0 = SIP is not enabled
# 1 = SIP is enabled
bIsSipEnabled="1"
./getSip2.sh $ip
userName=$(cat tempSip.txt | grep userName | awk -F '"' '{print $4}')
authName=$(cat tempSip.txt | grep authName | awk -F '"' '{print $4}')
authPassword=$(cat tempSip.txt | grep authPassword | awk -F '"' '{print $4}')
# 0 = AUTO
# 1 = OCS
# 2 = OCS_MANUAL
serverType=$(cat tempSip.txt | grep eSipServerType | awk '{print $2}' | awk -F ',' '{print $1}')
# 0 = registrar is not enabled
# 1 = registrar is enabled
bIsRegistrarEnabled="1"
#registrarHostName=$(cat tempSip.txt | grep registrarHostName | awk -F '"' '{print $4}')
registrarHostName=$registrarIP
# 0 = SIP proxy is not enabled
# 1 = SIP proxy is enabled
bIsProxyEnabled=$(cat tempSip.txt | grep IsProxyEnabled | awk '{print $2}' | awk -F ',' '{print $1}')
proxyHostName=$(cat tempSip.txt | grep proxyHostName | awk -F '"' '{print $4}')
# 0 = SIP uses direct mode registration
# 1 = SIP uses proxy mode registration
bUseProxyForRegistration=$(cat tempSip.txt | grep UseProxy | awk '{print $2}' | awk -F ',' '{print $1}')
# 0 = SIP auto transport
# 1 = SIP UDP only
# 2 = SIP TCP only
# 3 = SIP TLS only
transport=$(cat tempSip.txt | grep transport | awk '{print $2}' | awk -F ',' '{print $1}')
# 0 = SIP TCP not enabled
# 1 = SIP TCP enabled
bIsTransportTCP=$(cat tempSip.txt | grep IsTransportTCP | awk '{print $2}' | awk -F ',' '{print $1}')
internalServer="dddd"
externalServer="dsdsd"
# 0 = SIP Primary context
# 1 = SIP Secondary context
eContextType="1"


echo "AUTH is ${auth}"
b64auth=$(echo -n ${auth} | base64)
echo "IP is ${ip}"
echo "b64 is ${b64auth}"


session=$( curl -H "Authorization: LSBasic ${b64auth}" -H "Content-Type: application/json" http://$ip/rest/new | awk -F\" '/session/ { print $4 }' )
echo "SESSION is ${session}"


curl -H "Authorization: LSBasic ${b64auth}" -H "Content-Type: application/json" --data "{\"call\":\"Comm_setSipDetails\",\"params\":{\"pSipDetails\":{\"bIsSipEnabled\":${bIsSipEnabled},\"userName\":\"${userName}\",\"authName\":\"${authName}\",\"authPassword\":\"${authPassword}\",\"eSipServerType\":\"${serverType}\",\"sStructAuto\":{\"bIsRegistrarEnabled\":${bIsRegistrarEnabled},\"registrarHostName\":\"${registrarHostName}\",\"bIsProxyEnabled\":${bIsProxyEnabled},\"proxyHostName\":\"${proxyHostName}\",\"bUseProxyForRegistration\":${bUseProxyForRegistration},\"transport\":\"${transport}\"},\"sStructOCSManual\":{\"bIsTransportTCP\":${bIsTransportTCP},\"internalServer\":\"${internalServer}\",\"externalServer\":\"${externalServer}\"}},\"eContextType\":${eContextType}}}" http://${ip}/rest/request/${session}




