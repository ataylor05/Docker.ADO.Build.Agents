#!/bin/bash
echo "nameserver 8.8.8.8" > /etc/resolv.conf

set -e

source ./env.sh




if [ -n "$VSTS_AGENT_IGNORE" ]; then
  export VSO_AGENT_IGNORE=$VSO_AGENT_IGNORE,VSTS_AGENT_IGNORE,$VSTS_AGENT_IGNORE
fi

touch /vsts/.configure
rm -rf /vsts/agent
mkdir /vsts/agent

cd /vsts/bin

./Agent.Listener configure --unattended \
  --agent "$(hostname)" \
  --url "$AZP_ADO_URL" \
  --auth PAT \
  --token "$AZP_TOKEN" \
  --pool "$AZP_POOL" \
  --work "$AZP_WORK" \
  --acceptTeeEula \
  --replace & wait $!

./Agent.Listener run --once & wait $!
