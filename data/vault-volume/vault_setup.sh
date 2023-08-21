#!/bin/bash
#vault server execute
vault server -config /data/vault-base.hcl &

#Vault initialization and export of keys issued during vault initialization
sleep 10
if [ ! -e "/data/keyfile" ]; then
    touch /data/keyfile && vault operator init -tls-skip-verify  > /data/keyfile
fi
#input rootKey and Key to unseal MongoDB
mapfile keyparam < <( cat /data/keyfile |grep "Unseal Key"|cut -d " " -f 4)
export VAULT_TOKEN=`cat /data/keyfile |grep "Initial Root Token:"|cut -d " " -f4`

#Unseal execute
vault operator unseal -tls-skip-verify  ${keyparam[0]}
vault operator unseal -tls-skip-verify  ${keyparam[1]}
vault operator unseal -tls-skip-verify  ${keyparam[2]}

# Secret Engine enable
vault secrets enable -tls-skip-verify database

# Registor mongoDB's access info
# change value "allowed_roles" to next role
# change value "connectoin_url" to connection info for admin user
vault write -tls-skip-verify database/config/my-mongodb  \
    plugin_name=mongodb-database-plugin \
    allowed_roles="app-Dev" \
    connection_url=mongodb://root:root-password@db:27017/admin \

#Set expiration date and role of the issued access info from vault to access mongoDB 
# change value "creation_statements" to role of user
# change default_ttl and max_ttl to desired date of expiry 
vault write -tls-skip-verify database/roles/app-Dev \
    db_name=my-mongodb \
    creation_statements='{ "db": "APP_DB", "roles": [{"role": "readWrite", "db": "APP_DB"}] }' \
    default_ttl="1h" \
    max_ttl="24h"

#Execute loop not to finish script execution
while true;
    do sleep 1
done