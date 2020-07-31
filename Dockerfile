FROM ubuntu:18.04

ENV AZP_TOKEN=#{ADO-PAT}#
ENV AZP_POOL=aks-linux
ENV AZP_WORK=_work
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

# Ansible
RUN apt-get install ansible -y

# Ant
RUN apt-get install -y ant

# AzCopy
RUN cd /tmp && curl -L https://aka.ms/downloadazcopy-v10-linux -o azcopy.gz \
  && tar -zxvf azcopy.gz \
  && mv azcopy_linux*/azcopy /usr/bin \
  && chmod 777 /usr/bin/azcopy

# Azure CLI
ADD https://aka.ms/InstallAzureCLIDeb /tmp/deb_install.sh
RUN cd /tmp \
  && chmod +x deb_install.sh \
  && ./deb_install.sh

# Azure Devops Agent
RUN cd /tmp && wget $AdoAgentUrl \
  && mkdir /vsts \
  && tar -C /vsts -zxvf /tmp/vsts-agent-linux-x64-*.tar.gz

# Build tools
RUN apt-get install -y make cmake clang gcc g++

# Cloud Foundry CLI
RUN wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | apt-key add - \
  && echo "deb https://packages.cloudfoundry.org/debian stable main" | tee /etc/apt/sources.list.d/cloudfoundry-cli.list \
  && apt-get update \
  && apt-get install -y cf-cli

# Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
  && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  && apt-get update \
  && apt-get install -y docker-ce docker-ce-cli containerd.io

# Dotnet Core
RUN wget -q $DotNetCoreUrl -O /tmp/packages-microsoft-prod.deb \
  && dpkg -i /tmp/packages-microsoft-prod.deb \
  && add-apt-repository universe \
  && apt-get update -y \
  && apt-get install -y dotnet-sdk-3.1 \
  && apt-get install -y aspnetcore-runtime-3.1 \
  && apt-get install -y dotnet-runtime-3.1

# Gem
RUN apt-get install gem -y

# Gradle
RUN apt-get install -y gradle

# Git
RUN apt-get install -y git

# Go
RUN cd /tmp && wget $GoUrl \
  && tar -C /opt -zxvf go*.linux-amd64.tar.gz \
  && ln -s /opt/go/bin/go /usr/bin/go

# Google GCloud SDK
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
  && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - \
  && apt-get update -y \
  && apt-get install google-cloud-sdk -y

# Helm 2
RUN cd /tmp && wget $Helm2Url \
  && mkdir /opt/helm2 \
  && tar -C /opt/helm2 -zxvf helm-v2*-linux-amd64.tar.gz \
  && ln -s /opt/helm2/linux-amd64/helm /usr/bin/helm2 \
  && ln -s /opt/helm2/linux-amd64/tiller /usr/bin/tiller

# Helm 3
RUN cd /tmp && wget $Helm3Url \
  && mkdir /opt/helm3 \
  && tar -C /opt/helm3 -zxvf helm-v3*-linux-amd64.tar.gz \
  && ln -s /opt/helm3/linux-amd64/helm /usr/bin/helm

# Jq
RUN apt-get install -y jq

# Kubectl
RUN apt-get install -y kubectl

# Maven
RUN apt-get install -y maven

# MySQL Client
RUN apt-get install -y mysql-client-5.7

# Node JS
RUN curl -sL $NodeJsUrl | bash - \
  && apt-get install -y nodejs

# Packer
RUN cd /tmp && wget $PackerUrl \
  && unzip packer*linux_amd64.zip \
  && mv packer /usr/bin \
  && chmod 777 /usr/bin/packer

# PHP
RUN apt-get install -y php php-cli php-mysql php-cgi php-gd php-mbstring

# PHP Composer
RUN curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php \
  && php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Powershell
RUN apt-get install -y powershell

#Python2
RUN apt-get install -y python-pip

# Python3
RUN apt-get install -y python3 python3-pip

# Ruby
RUN apt-get install -y ruby

# Rsync
RUN apt-get install -y rsync

# Salesforce CLI
RUN curl -sS $SalesForceCliUrl -o /tmp/sfdx-linux-amd64.tar.xz \
  && cd /tmp \
  && mkdir sfdx \
  && tar xJf sfdx-linux-amd64.tar.xz -C sfdx --strip-components 1 \
  && ./sfdx/install

# Subversion
RUN apt-get install -y subversion

# Swift
RUN apt-get install -y swift

# Terraform
RUN cd /tmp && wget $TerraformUrl \
  && unzip terraform_*.zip \
  && mv terraform /usr/bin \
  && chmod 777 /usr/bin/terraform

# Vault
RUN cd /tmp && wget $VaultUrl \
  && unzip vault_*.zip \
  && mv vault /usr/bin \
  && chmod 777 /usr/bin/vault

# Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt update \
  && apt-get install -y yarn

RUN rm -rf /tmp/*

WORKDIR /vsts

COPY ./start.sh .
COPY ./exports.sh .
RUN chmod +x start.sh exports.sh
RUN ./exports.sh

CMD . ~/.profile && ./start.sh
