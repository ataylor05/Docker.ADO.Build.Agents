FROM ubuntu:18.04

ENV AZP_TOKEN=$(ado-pat)
ENV AZP_POOL=aks-linux
ENV AZP_WORK=_work
ENV AZP_ADO_ORG=allan05
ENV DEBIAN_FRONTEND=noninteractive
ENV AdoAgentUrl=https://vstsagentpackage.azureedge.net/agent/2.172.2/vsts-agent-linux-x64-2.172.2.tar.gz
ENV DotNetCoreUrl=https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
ENV GoUrl=https://golang.org/dl/go1.14.6.linux-amd64.tar.gz
ENV Helm2Url=https://get.helm.sh/helm-v2.16.9-linux-arm64.tar.gz
ENV Helm3Url=https://get.helm.sh/helm-v3.2.4-linux-arm64.tar.gz
ENV NodeJsUrl=https://deb.nodesource.com/setup_13.x
ENV PackerUrl=https://releases.hashicorp.com/packer/1.6.1/packer_1.6.1_linux_amd64.zip
ENV SalesForceCliUrl=https://developer.salesforce.com/media/salesforce-cli/sfdx-linux-amd64.tar.xz
ENV TerraformUrl=https://releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_linux_amd64.zip
ENV VaultUrl=https://releases.hashicorp.com/vault/1.5.0/vault_1.5.0_linux_amd64.zip
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update \
&& apt-get install -y --no-install-recommends \
  apt-transport-https \
  ca-certificates \
  curl \
  ftp \
  gnupg \
  iputils-ping \
  lsb-release \
  netcat \
  software-properties-common \
  tar \
  telnet \
  unzip \
  vim \
  wget \
  zip

# Azure Devops Agent
RUN cd /tmp && wget $AdoAgentUrl \
  && mkdir /vsts \
  && tar -C /vsts -zxvf /tmp/vsts-agent-linux-x64-*.tar.gz

RUN rm -rf /tmp/*

WORKDIR /vsts

COPY start.sh /vsts
COPY exports.sh /vsts
RUN chmod +x /vsts/start.sh /vsts/exports.sh

CMD ./start.sh
