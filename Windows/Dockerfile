# escape=`
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019

ENV AZP_URL=https://dev.azure.com/allan05
ENV AZP_WORK=c:\azp\_work
ENV AZP_POOL=aks-windows
ENV AZP_TOKEN=#{ado-pat}#
ENV ADO_AGENT_URL=https://vstsagentpackage.azureedge.net/agent/2.172.2/vsts-agent-win-x64-2.172.2.zip
ENV CMAKE_URL=https://github.com/Kitware/CMake/releases/download/v3.18.1/cmake-3.18.1-win64-x64.msi
ENV CURL_URL=https://curl.haxx.se/windows/dl-7.71.1/curl-7.71.1-win64-mingw.zip
ENV GIT_URL=https://github.com/git-for-windows/git/releases/download/v2.28.0.windows.1/Git-2.28.0-64-bit.exe
ENV JQ_URL=https://github.com/stedolan/jq/releases/download/jq-1.6/jq-win64.exe
ENV PACKER_URL=https://releases.hashicorp.com/packer/1.6.1/packer_1.6.1_windows_amd64.zip
ENV PYTHON3_URL=https://www.python.org/ftp/python/3.8.5/python-3.8.5.exe
ENV TERRAFORM_URL=https://releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_windows_amd64.zip
ENV VAULT_URL=https://releases.hashicorp.com/vault/1.5.0/vault_1.5.0_windows_amd64.zip


RUN mkdir c:\azp; `
    mkdir c:\bin; 

# ADO Agent
RUN $ProgressPreference = 'SilentlyContinue'; `
    Invoke-WebRequest -Uri $env:ADO_AGENT_URL -OutFile c:\azp\vsts-agent-win.zip; `
    Expand-Archive -Path c:\azp\vsts-agent-win.zip -DestinationPath c:\azp\agent; `
    Remove-Item -Path c:\azp\vsts-agent-win.zip -Force

# AzCopy
RUN $ProgressPreference = 'SilentlyContinue'; `
    Invoke-WebRequest https://aka.ms/downloadazcopy-v10-windows -OutFile c:\azp\azcopyv10.zip; `
    Expand-Archive -Path c:\azp\azcopyv10.zip -DestinationPath c:\TEMP; `
    cd C:\TEMP\azcopy*; `
    cp azcopy.exe c:\bin

# Azure CLI
RUN $ProgressPreference = 'SilentlyContinue'; `
    Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; `
    Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; `
    rm .\AzureCLI.msi

# Cmake
RUN $ProgressPreference = 'SilentlyContinue'; `
    Invoke-WebRequest -Uri $env:CMAKE_URL -OutFile c:\azp\cmake.msi; `
    Start-Process -FilePath c:\azp\cmake.msi -Wait

# Curl
RUN $ProgressPreference = 'SilentlyContinue'; `
    Invoke-WebRequest -Uri $env:CURL_URL -OutFile c:\azp\curl.zip; `
    Expand-Archive -Path c:\azp\curl.zip -DestinationPath c:\TEMP; `
    Remove-Item -Path c:\azp\curl.zip -Force; `
    cd C:\TEMP\curl*; `
    mv * ..
    
# Docker
RUN cd /; `
    git clone https://github.com/docker/cli.git
    
# Git
RUN $ProgressPreference = 'SilentlyContinue'; `
    Invoke-WebRequest -Uri $env:GIT_URL -OutFile c:\azp\git.exe; `
    Start-Process -FilePath c:\azp\git.exe -ArgumentList "/SILENT" -Wait; `
    Remove-Item -Path c:\azp\git.exe -Force

# Jq
RUN $ProgressPreference = 'SilentlyContinue'; `
    Invoke-WebRequest -Uri $env:JQ_URL -OutFile c:\bin\jq.exe

# Packer
RUN $ProgressPreference = 'SilentlyContinue'; `
    Invoke-WebRequest -Uri $env:PACKER_URL -OutFile c:\azp\packer.zip; `
    Expand-Archive -Path c:\azp\packer.zip -DestinationPath c:\bin; `
    Remove-Item -Path c:\azp\packer.zip -Force

# Python 3
#RUN Invoke-WebRequest -Uri $env:PYTHON3_URL -OutFile c:\azp\python3.exe; `
#    Start-Process -FilePath c:\azp\python3.exe -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1 Include_exe=1 Include_pip=1 Include_lib=1 Include_test=1" -Wait
    #Remove-Item -Path c:\azp\python3.exe -Force

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

WORKDIR c:\azp

COPY start.ps1 c:\\azp\\start.ps1

RUN setx /M PATH "C:\bin;C:\Program Files\CMake\bin;C:\curl\bin;%PATH%"

ENTRYPOINT C:\\BuildTools\\Common7\\Tools\\VsDevCmd.bat && powershell.exe -ExecutionPolicy Bypass c:\\azp\\start.ps1
