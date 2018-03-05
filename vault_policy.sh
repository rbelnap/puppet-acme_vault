#!/bin/bash

# this script sets up policies in vault to support reading and writing certs.
# Comments at the bottom provide examples for how to create tokens using these
# policies, to be distributed to machines.

cert_read='
path "secret/letsencrypt/*" {
  capabilities = ["read"]
}
'

cert_write='
path "secret/letsencrypt/*" {
  capabilities = ["create", "update", "read"]
}
path "secret/dns_api/token" {
  capabilities = ["read"]
}
'

# the key here changed from "rules" to "policy" in v0.9, this is a basic check

if vault --version | grep -q 'v0.8'
then
    K=rules
else
    K=policy
fi

vault write sys/policy/cert_read $K=@<(echo $cert_read)
vault write sys/policy/cert_write $K=@<(echo $cert_write)

# create periodic tokens:
# these tokens have a period of 20 days, they will expire if not renewed.

# vault token create -policy=cert_write -period=1728000 -metadata="host=testbox"
# vault token create -policy=cert_read -period=1728000 -metadata="host=testbox"

# secret for dns api
# vault write secret/dns_api/token value=$(cat)
