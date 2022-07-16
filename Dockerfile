FROM mcr.microsoft.com/powershell:latest

WORKDIR /usr/src/app

#VOLUME /powershell

RUN echo "Invoke-ScriptAnalyzer" > info.txt
RUN pwsh -command "Install-Module -Name PSScriptAnalyzer -Force"
RUN pwsh -command "Import-Module PSScriptAnalyzer"
