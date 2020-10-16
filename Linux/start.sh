#!/bin/bash
set -e

echo "nameserver 192.168.4.2" >> /etc/resolv.conf

if [ -n "$AZP_WORK" ]; then
  mkdir -p "$AZP_WORK"
fi

export AGENT_ALLOW_RUNASROOT="1"

AZP_TOKEN=$(cat /azp/.token)
rm -f /azp/.token

# Ignore environment variables
export VSO_AGENT_IGNORE=AZP_TOKEN,AZP_TOKEN_FILE,AZP_POOL,AZP_URL,AZP_WORK,AGENT_ALLOW_RUNASROOT,Agent.HomeDirectory
export VSO_AGENT_IGNORE=$VSO_AGENT_IGNORE,KUBERNETES_PORT,KUBERNETES_PORT_443_TCP,KUBERNETES_PORT_443_TCP_ADDR,KUBERNETES_PORT_443_TCP_PORT,KUBERNETES_PORT_443_TCP_PROTO,KUBERNETES_SERVICE_HOST,KUBERNETES_SERVICE_PORT,KUBERNETES_SERVICE_PORT_HTTPS
export VSO_AGENT_IGNORE=$VSO_AGENT_IGNORE,AdoAgentUrl,DotNetCoreUrl,GoUrl,Helm3Url,NodeJsUrl,PackerUrl,SalesForceCliUrl,TerraformUrl,VaultUrl,DEBIAN_FRONTEND,HOME,HOSTNAME,OLDPWD,PATH,PWD,sh,_
export VSO_AGENT_IGNORE=$VSO_AGENT_IGNORE,VSO_AGENT_IGNORE

AZP_AGENT_RESPONSE=$(curl -LsS -u user:$AZP_TOKEN -H 'Accept:application/json;api-version=3.0-preview' "$AZP_URL/_apis/distributedtask/packages/agent?platform=linux-x64")
if echo "$AZP_AGENT_RESPONSE" | jq . >/dev/null 2>&1; then
  AZP_AGENTPACKAGE_URL=$(echo "$AZP_AGENT_RESPONSE" | jq -r '.value | map([.version.major,.version.minor,.version.patch,.downloadUrl]) | sort | .[length-1] | .[3]')
fi
if [ -z "$AZP_AGENTPACKAGE_URL" -o "$AZP_AGENTPACKAGE_URL" == "null" ]; then
  echo 1>&2 "error: could not determine a matching Azure Pipelines agent - check that account '$AZP_URL' is correct and the token is valid for that account"
  exit 1
fi
curl -LsS $AZP_AGENTPACKAGE_URL | tar -xz & wait $!


./config.sh --unattended \
  --agent "$(hostname)" \
  --url "$AZP_URL" \
  --auth PAT \
  --token $AZP_TOKEN \
  --pool "$AZP_POOL" \
  --work "$AZP_WORK" \
  --replace \
  --acceptTeeEula & wait $!

unset AZP_TOKEN

cd bin
./Agent.Listener run --once & wait $!
