# escape=`
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019

ENV AZP_URL=https://dev.azure.com/allan05
ENV AZP_WORK=c:\azp\_work
ENV AZP_POOL=aks-windows
ENV AZP_TOKEN=#{ado-pat}#
ENV ADO_AGENT_URL=https://vstsagentpackage.azureedge.net/agent/2.172.2/vsts-agent-win-x64-2.172.2.zip
ENV ANT_HOME=c:\ant
ENV ANT_URL=http://mirrors.advancedhosters.com/apache//ant/binaries/apache-ant-1.10.8-bin.zip
ENV CLOUD_FOUNDRY_CLI_URL=https://packages.cloudfoundry.org/stable?release=windows64&source=github
ENV CMAKE_URL=https://github.com/Kitware/CMake/releases/download/v3.18.1/cmake-3.18.1-win64-x64.msi
ENV CURL_URL=https://curl.haxx.se/windows/dl-7.71.1/curl-7.71.1-win64-mingw.zip
ENV DOTNET_CORE_URL=https://dotnet.microsoft.com/download/dotnet-core/thank-you/runtime-aspnetcore-3.1.6-windows-x64-installer
ENV GCLOUD_SDK_URL=https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe
ENV GIT_URL=https://github.com/git-for-windows/git/releases/download/v2.28.0.windows.1/Git-2.28.0-64-bit.exe
ENV GRADLE_URL=https://services.gradle.org/distributions/gradle-6.5.1-all.zip
ENV GO_URL=https://golang.org/dl/go1.14.6.windows-amd64.msi
ENV HELM2_URL=https://get.helm.sh/helm-v2.16.9-windows-amd64.zip
ENV HELM3_URL=https://get.helm.sh/helm-v3.2.4-windows-amd64.zip
ENV JDK_URL=https://download.oracle.com/otn-pub/java/jdk/14.0.2+12/205943a0976c4ed48cb16f1043c5c647/jdk-14.0.2_windows-x64_bin.exe
ENV JQ_URL=https://github.com/stedolan/jq/releases/download/jq-1.6/jq-win64.exe
ENV KUBECTL_URL=https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/windows/amd64/kubectl.exe
ENV MAVEN_URL=https://mirror.olnevhost.net/pub/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.zip
ENV MYSQL_URL=
ENV NODEJS_URL=https://nodejs.org/dist/v12.18.3/node-v12.18.3-x64.msi
ENV PACKER_URL=https://releases.hashicorp.com/packer/1.6.1/packer_1.6.1_windows_amd64.zip
ENV PYTHON3_URL=https://www.python.org/ftp/python/3.8.5/python-3.8.5.exe
ENV RUBY_URL=https://rubyinstaller.org/downloads/
ENV SALESFORCE_CLI_URL=https://developer.salesforce.com/media/salesforce-cli/sfdx-windows-amd64.exe
ENV TERRAFORM_URL=https://releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_windows_amd64.zip
ENV VAULT_URL=https://releases.hashicorp.com/vault/1.5.0/vault_1.5.0_windows_amd64.zip


RUN mkdir c:\ant; `
    mkdir c:\azp; `
    mkdir c:\bin; `
    mkdir c:\TEMP

# ADO Agent
RUN $ProgressPreference = 'SilentlyContinue'; `
    Invoke-WebRequest -Uri $env:ADO_AGENT_URL -OutFile c:\azp\vsts-agent-win.zip; `
    Expand-Archive -Path c:\azp\vsts-agent-win.zip -DestinationPath c:\azp\agent; `
    Remove-Item -Path c:\azp\vsts-agent-win.zip -Force

# Ant
RUN $ProgressPreference = 'SilentlyContinue'; `
    Invoke-WebRequest -Uri $env:ANT_URL -OutFile c:\TEMP\ant.zip; `
    Expand-Archive -Path c:\TEMP\ant.zip -DestinationPath c:\ant; `
    cd c:\ant\apache*; `
    mv * ..; `
    cd ..; `
    Remove-Item apache-ant-* -Recurse
    
    
# AzCopy
RUN $ProgressPreference = 'SilentlyContinue'; `
    Invoke-WebRequest https://aka.ms/downloadazcopy-v10-windows -OutFile c:\azp\azcopyv10.zip; `
    Expand-Archive -Path c:\azp\azcopyv10.zip -DestinationPath c:\TEMP; `
    cd C:\TEMP\azcopy*; `
    cp azcopy.exe c:\bin; `
    Remove-Item -Path c:\azp\azcopyv10.zip -Force

# Azure CLI
RUN $ProgressPreference = 'SilentlyContinue'; `
    Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; `
    Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; `
    rm .\AzureCLI.msi

# Cmake
RUN $ProgressPreference = 'SilentlyContinue'; `
    Invoke-WebRequest -Uri $env:CMAKE_URL -OutFile c:\azp\cmake.msi; `
    Start-Process -FilePath c:\azp\cmake.msi -Wait; `
    Remove-Item -Path c:\azp\cmake.msi -Force

# Curl
RUN $ProgressPreference = 'SilentlyContinue'; `
    Invoke-WebRequest -Uri $env:CURL_URL -OutFile c:\azp\curl.zip; `
    Expand-Archive -Path c:\azp\curl.zip -DestinationPath c:\TEMP; `
    Remove-Item -Path c:\azp\curl.zip -Force; `
    cd C:\TEMP\curl*; `
    mv * ..
    
# Git
RUN $ProgressPreference = 'SilentlyContinue'; `
    Invoke-WebRequest -Uri $env:GIT_URL -OutFile c:\azp\git.exe; `
    Start-Process -FilePath c:\azp\git.exe -ArgumentList "/SILENT" -Wait; `
    Remove-Item -Path c:\azp\git.exe -Force

# Docker
COPY docker-windows-amd64.exe C:\bin\docker.exe

# Java Development Kit
COPY jdk.ps1 C:\TEMP\jdk.ps1
RUN C:\TEMP\jdk.ps1

# Jq
RUN $ProgressPreference = 'SilentlyContinue'; `
    Invoke-WebRequest -Uri $env:JQ_URL -OutFile c:\bin\jq.exe

# Packer
RUN $ProgressPreference = 'SilentlyContinue'; `
    Invoke-WebRequest -Uri $env:PACKER_URL -OutFile c:\azp\packer.zip; `
    Expand-Archive -Path c:\azp\packer.zip -DestinationPath c:\bin; `
    Remove-Item -Path c:\azp\packer.zip -Force

# Python 3
RUN Invoke-WebRequest -Uri $env:PYTHON3_URL -OutFile c:\azp\python3.exe; `
    cmd /c start /wait c:\azp\python3.exe /quiet TargetDir=C:\Python36-x64 Shortcuts=0 Include_launcher=0 InstallLauncherAllUsers=0 Include_exe=1 Include_pip=1 Include_lib=1 Include_test=1; `
    Remove-Item -Path c:\azp\python3.exe -Force; `
    C:\Python36-x64\Scripts\pip install requests kubernetes numpy pandas pyyaml

# Telnet
RUN dism /online /Enable-Feature /FeatureName:TelnetClient

# Terraform
RUN $ProgressPreference = 'SilentlyContinue'; `
    Invoke-WebRequest -Uri $env:TERRAFORM_URL -OutFile c:\azp\terraform.zip; `
    Expand-Archive -Path c:\azp\terraform.zip -DestinationPath c:\bin; `
    Remove-Item -Path c:\azp\terraform.zip -Force

# Vault
RUN $ProgressPreference = 'SilentlyContinue'; `
    Invoke-WebRequest -Uri $env:VAULT_URL -OutFile c:\azp\vault.zip; `
    Expand-Archive -Path c:\azp\vault.zip -DestinationPath c:\bin; `
    Remove-Item -Path c:\azp\vault.zip -Force

# Visual Studio 2019 Build Tools
SHELL ["cmd", "/S", "/C"]
ADD https://aka.ms/vs/16/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe
RUN C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
    --installPath C:\BuildTools `
    --add Microsoft.VisualStudio.Workload.AzureBuildTools `
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10240 `
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10586 `
    --remove Microsoft.VisualStudio.Component.Windows10SDK.14393 `
    --remove Microsoft.VisualStudio.Component.Windows81SDK `
 || IF "%ERRORLEVEL%"=="3010" EXIT 0

# Clean up
RUN Remove-Item C:\TEMP -Recurse


WORKDIR c:\azp

COPY start.ps1 c:\azp\start.ps1

RUN setx /M PATH "C:\bin;C:\ant\bin;C:\Program Files\CMake\bin;C:\curl\bin;C:\Python36-x64;C:\Python36-x64\Scripts;%PATH%"

ENTRYPOINT C:\\BuildTools\\Common7\\Tools\\VsDevCmd.bat && powershell.exe -ExecutionPolicy Bypass c:\\azp\\start.ps1
