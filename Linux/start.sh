#!/bin/bash
set -e

if [ -z "$AZP_TOKEN_FILE" ]; then
  if [ -z "$AZP_TOKEN" ]; then
    echo 1>&2 "error: missing AZP_TOKEN environment variable"
    exit 1
  fi

  AZP_TOKEN_FILE=/azp/.token
  echo -n $AZP_TOKEN > "$AZP_TOKEN_FILE"
fi

unset AZP_TOKEN

if [ -n "$AZP_WORK" ]; then
  mkdir -p "$AZP_WORK"
fi

rm -rf /azp/agent
mkdir /azp/agent
cd /azp/agent

export AGENT_ALLOW_RUNASROOT="1"

export ADO_AGENT_IGNORE=ADO_AGENT_LINUX2_SERVICE_PORT,ADO_AGENT_LINUX2_PORT_443_TCP_PORT,ADO_AGENT_LINUX2_PORT_443_TCP_PROTO,ADO_AGENT_LINUX2_SERVICE_HOSTInteractiveSession,ADO_AGENT_LINUX2_PORT,ADO_AGENT_LINUX2_PORT_443_TCP,ADO_AGENT_LINUX2_PORT_443_TCP_ADDR,ADO_AGENT_LINUX_PORT_443_TCP_PROTO,ADO_AGENT_LINUX_SERVICE_HOST,ADO_AGENT_LINUX_SERVICE_PORT,ADO_AGENT_LINUX_PORT_443_TCP_PORT,ADO_AGENT_LINUX_PORT,ADO_AGENT_LINUX_PORT_443_TCP,ADO_AGENT_LINUX_PORT_443_TCP_ADDR
export AZP_IGNORE=AZP_TOKEN,AZP_TOKEN_FILE,ZP_WORK,AZP_POOL
export KUBERNETES_IGNORE=KUBERNETES_PORT,KUBERNETES_PORT_443_TCP,KUBERNETES_PORT_443_TCP_ADDR,KUBERNETES_PORT_443_TCP_PORT,KUBERNETES_PORT_443_TCP_PROTO,KUBERNETES_SERVICE_HOST,KUBERNETES_SERVICE_PORT,KUBERNETES_SERVICE_PORT_HTTPS
export MISC_IGNORE=AGENT_ALLOW_RUNASROOT,DEBIAN_FRONTEND,HOME,InteractiveSession,OLDPWD,PATH,PWD,sh
export VSO_AGENT_IGNORE=VSO_AGENT_IGNORE,ADO_AGENT_IGNORE,AZP_IGNORE,KUBERNETES_IGNORE,MISC_IGNORE


AZP_AGENT_RESPONSE=$(curl -LsS \
  -u user:$(cat "$AZP_TOKEN_FILE") \
  -H 'Accept:application/json;api-version=3.0-preview' \
  "$AZP_URL/_apis/distributedtask/packages/agent?platform=linux-x64")

if echo "$AZP_AGENT_RESPONSE" | jq . >/dev/null 2>&1; then
  AZP_AGENTPACKAGE_URL=$(echo "$AZP_AGENT_RESPONSE" \
    | jq -r '.value | map([.version.major,.version.minor,.version.patch,.downloadUrl]) | sort | .[length-1] | .[3]')
fi

if [ -z "$AZP_AGENTPACKAGE_URL" -o "$AZP_AGENTPACKAGE_URL" == "null" ]; then
  echo 1>&2 "error: could not determine a matching Azure Pipelines agent - check that account '$AZP_URL' is correct and the token is valid for that account"
  exit 1
fi

curl -LsS $AZP_AGENTPACKAGE_URL | tar -xz & wait $!

./config.sh --unattended \
  --agent "${AZP_AGENT_NAME:-$(hostname)}" \
  --url "$AZP_URL" \
  --auth PAT \
  --token $(cat "$AZP_TOKEN_FILE") \
  --pool "${AZP_POOL:-Default}" \
  --work "${AZP_WORK:-_work}" \
  --replace \
  --acceptTeeEula & wait $!

rm $AZP_TOKEN_FILE

cd /azp/agent/bin
./Agent.Listener run --once & wait $!
