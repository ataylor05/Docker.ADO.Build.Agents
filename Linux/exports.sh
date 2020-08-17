#!/bin/bash

echo "export AnsibleVersion=$(ansible --version | grep "^ansible" | cut -d " " -f 2)" >> ~/.profile

echo "export AntVersion=$(ant -version | cut -d " " -f 4)" >> ~/.profile

echo "export AzCopyVersion=$(azcopy --version | cut -d " " -f 3)" >> ~/.profile

echo "export AzureCliVersion=$(az version | jq '.["azure-cli"]')" >> ~/.profile

echo "export ClangVersion=$(clang --version | grep "clang version" | cut -d " " -f 3 | cut -d "-" -f 1)" >> ~/.profile

echo "export CmakeVersion=$(cmake --version | grep "cmake version" | cut -d " " -f 3)" >> ~/.profile

echo "export CloudFoundryCliVersion=$(cf -v | cut -d " " -f 3 | cut -d "+" -f 1)" >> ~/.profile

echo "export ComposerVersion=$(composer --version | cut -d " " -f 3)" >> ~/.profile

echo "CurlVersion=$(curl --version | grep "curl" | cut -d " " -f 2)" >> ~/.profile

dockerver=$(docker --version | cut -d " " -f 3)
echo "export DockerVersion=${dockerver::-1}" >> ~/.profile

echo "export DotnetCoreVersion=$(dotnet --version)" >> ~/.profile

echo "export GemVersion=$(gem -v)" >> ~/.profile

echo "export GccVersion=$(gcc --version | grep "gcc" | cut -d " " -f 4)" >> ~/.profile

echo "export GCloudCliVersion=$(gcloud --version | grep "Google" | cut -d " " -f 4)" >> ~/.profile

echo "export GitVersion=$(git --version | cut -d " " -f 3)" >> ~/.profile

echo "export GPlusPlusVersion=$(g++ --version | grep "g++" | cut -d " " -f 4)" >> ~/.profile

echo "export GoVersion=$(go version | cut -d " " -f 3 | cut -d "o" -f 2)" >> ~/.profile
echo "export GOPATH=/root" >> ~/.profile
echo "export GOROOT=/opt/go" >> ~/.profile
echo "export PATH=$PATH:/opt/go/bin:$GOPATH/bin" >> ~/.profile

echo "export GradleVersion=$(gradle -v 2> /dev/null | grep "Gradle" | cut -d " " -f 2)" >> ~/.profile

echo "export Helm2Version=$(helm2 version 2> /dev/null | cut -d ":" -f 3 | cut -d '"' -f 2 | cut -d "v" -f 2)" >> ~/.profile

echo "export Helm3Version=$(helm version 2> /dev/null | cut -d ":" -f 2 | cut -d '"' -f 2 | cut -d "v" -f 2)" >> ~/.profile

echo "export JavaVersion=$(java --version | grep "openjdk" | cut -d " " -f 2)" >> ~/.profile

echo "export JqVersion=$(jq --version | cut -d "-" -f 2)" >> ~/.profile

echo "export KubectlVersion=$(kubectl version --short --client=true | grep "Client" | cut -d " " -f 3 | cut -d "v" -f 2)" >> ~/.profile

echo "export MakeVersion=$(make --version | grep "Make" | cut -d " " -f 3)" >> ~/.profile

echo "export MavenVersion=$(mvn --version | grep "Apache" | cut -d " " -f 3)" >> ~/.profile

echo "export MySqlClientVersion=$(mysql --version | cut -d " " -f 4)" >> ~/.profile

echo "export NetCatVersion=$(dpkg -l | grep "TCP/IP swiss army knife -- transitional package" | cut -d " " -f 35 | cut -d "-" -f 1)" >> ~/.profile

echo "export NpmVersion=$(npm --version)" >> ~/.profile

echo "export NodeJsVersion=$(node --version | cut -d "v" -f 2)" >> ~/.profile

echo "export PackerVersion=$(packer --version)" >> ~/.profile

echo "export PhpVersion=$(php --version | grep "cli" | cut -d " " -f 2 | cut -d "-" -f 1)" >> ~/.profile

echo "export PowershellCoreVersion=$(pwsh --version |  cut -d " " -f 2)" >> ~/.profile

echo "export Python2Version=$(python --version 2>&1 | cut -d " " -f 2)" >> ~/.profile

echo "export Python3Version=$(python3 --version |  cut -d " " -f 2)" >> ~/.profile

echo "export RsyncVersion=$(rsync --version | grep "protocol version" | cut -d " " -f 4)" >> ~/.profile

echo "export RubyVersion=$(ruby --version | cut -d " " -f 2)" >> ~/.profile

echo "export SalesForceCliVersion=$(sfdx --version | cut -d "/" -f 2 | cut -d "-" -f 1)" >> ~/.profile

echo "export TarVersion=$(tar --version | grep "tar" | cut -d " " -f 4)" >> ~/.profile

echo "export TelnetVersion=$(dpkg -l | grep "basic telnet" | cut -d " " -f 35 | cut -d "-" -f 1)" >> ~/.profile

echo "export TerraformVersion=$(terraform version | grep "Terraform v" | cut -d " " -f 2 | cut -d "v" -f 2)" >> ~/.profile

echo "export UnzipVersion=$(unzip -v | grep "by Debian" | cut -d " " -f 2)" >> ~/.profile

echo "export VaultVersion=$(vault --version | cut -d " " -f 2 | cut -d "v" -f 2)" >> ~/.profile

echo "export VimVersion=$(vim --version | grep "IMproved" | cut -d " " -f 5)" >> ~/.profile

echo "export WgetVersion=$(wget --version | grep "GNU Wget" | cut -d " " -f 3)" >> ~/.profile

echo "export YarnVersion=$(yarn --version)" >> ~/.profile

echo "export ZipVersion=$(zip -v | grep "This is Zip" | cut -d " " -f 4)" >> ~/.profile
