# SetSip2IP.sh
CURL against Icon API to configure sip reg 2 - specifically the Sip2 registrar IP

USAGE: You can invoke this script in two ways

- ./setSip2IP.sh <registrarIP> <password> <ExampleFile.txt>
- ./batchRun.sh <registrarIP> <password> <ExampleFile.txt>
  
Notes* <br />
Customer will need a Linux or MAC machine with CURL utility installed.  
Password parameter is optional.  
Script assumes a default password of ‘admin/admin’ if no password parameter is given.  

Optional batchRun.sh calls SetSip2IP.sh against a file with a list of IPs the script will operate over. See ExampleFile.txt for formatting examples.

