#!/bin/bash
set -e

if [ -n "$AZP_WORK" ]; then
  mkdir -p "$AZP_WORK"
fi

export AGENT_ALLOW_RUNASROOT="1"

# Ignore environment variables
export VSO_AGENT_IGNORE=AZP_TOKEN,AZP_TOKEN_FILE,AZP_POOL,AZP_URL,AZP_WORK,AGENT_ALLOW_RUNASROOT,Agent.HomeDirectory
export VSO_AGENT_IGNORE=$VSO_AGENT_IGNORE,KUBERNETES_PORT,KUBERNETES_PORT_443_TCP,KUBERNETES_PORT_443_TCP_ADDR,KUBERNETES_PORT_443_TCP_PORT,KUBERNETES_PORT_443_TCP_PROTO,KUBERNETES_SERVICE_HOST,KUBERNETES_SERVICE_PORT,KUBERNETES_SERVICE_PORT_HTTPS
export VSO_AGENT_IGNORE=$VSO_AGENT_IGNORE,AdoAgentUrl,DotNetCoreUrl,GoUrl,Helm3Url,NodeJsUrl,PackerUrl,SalesForceCliUrl,TerraformUrl,VaultUrl,DEBIAN_FRONTEND,HOME,HOSTNAME,OLDPWD,PATH,PWD,sh,_
export VSO_AGENT_IGNORE=$VSO_AGENT_IGNORE,VSO_AGENT_IGNORE

AZP_TOKEN=$(cat /azp/.token)
rm -f /azp/.token

./config.sh --unattended \
  --agent "$(hostname)" \
  --url "$AZP_URL" \
  --auth PAT \
  --token $AZP_TOKEN \
  --pool "$AZP_POOL" \
  --work "$AZP_WORK" \
  --replace \
  --acceptTeeEula & wait $!

cd bin
./Agent.Listener run --once & wait $!

cd ..
./config.sh remove --unattended \
      --auth PAT \
      --token $AZP_TOKEN
