# escape=`
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019

ENV AZP_URL=https://dev.azure.com/allan05
ENV AZP_WORK=c:\azp\_work
ENV AZP_POOL=aks-windows
ENV AZP_TOKEN=#{ado-pat}#
ENV ADO_AGENT_URL=https://vstsagentpackage.azureedge.net/agent/2.172.2/vsts-agent-win-x64-2.172.2.zip
ENV PYTHON3_URL=https://www.python.org/ftp/python/3.8.5/python-3.8.5.exe

RUN mkdir c:\\azp 
RUN mkdir c:\\bin


# Python 3
RUN Invoke-WebRequest -Uri $env:PYTHON3_URL -OutFile c:\azp\python3.exe
RUN c:\azp\python3.exe /quiet InstallAllUsers=1 PrependPath=1 Include_exe=1 Include_pip=1 Include_lib=1 Include_test=1
RUN Remove-Item -Path c:\azp\python3.exe -Force

# ADO Agent
RUN Invoke-WebRequest -Uri $env:ADO_AGENT_URL -OutFile c:\azp\vsts-agent-win.zip

RUN Expand-Archive -Path "c:\azp\vsts-agent-win.zip" -DestinationPath "c:\azp\agent"

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

ENTRYPOINT C:\\BuildTools\\Common7\\Tools\\VsDevCmd.bat && powershell.exe -ExecutionPolicy Bypass c:\\azp\\start.ps1
