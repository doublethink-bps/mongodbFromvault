# Connect MongoDB with login information issued from vault

It login to MongoDB with username and password issued from vault.

MongDB and vault Server is build in docker.

The docker-compose.yaml is for build those.

## Enviroment

・Docker 24.0.2, build cb74dfc 

・Docker Compose version v2.17.3

・mongodb 6.0.8

・vault 1.13.3

## How to use

create certificate with the following command
```
openssl genrsa 2048 > ./data/vault-volume/vault_server.key
openssl req -new -key vault_server.key > ./data/vault-volume/vault_server.csr
```
When .csr file will be creating,input data follow the display message.
After create it,execute the follow command.
```
openssl x509 -in vault_server.csr -days 365 -req -sha256 -signkey vault_server.key > ./data/vault-volume/server.crt
```
change parameter in vault_setup.sh 
(confilm comment in vault_setup.sh ,when parameter must be changed.)

After move ./data, build docker enviroment with execute docker compose 
```
docker compose up -d
```
login to vault and issue password and user 
```
docker compose exec -it vault /bin/bash
vault read database/creds/app-Dev
```
change "app-Dev" in the above command to the created role in vault_setup.sh 

After issue login info,login to mongodb
```
docker compose exec -it db /bin/bash
mongosh -u <issue user> <database name>
```


