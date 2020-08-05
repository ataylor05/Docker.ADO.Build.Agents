# Docker.ADO.Build.Agents
This project builds Docker images for use in Azure Devops Pipelines as a build agent.  The intended runtime is Azure Kubernetes Service (AKS) but you could run on a regular docker host if you wanted to.  This repo provides Terraform scripts which could help in deploying an [AKS build service](https://github.com/ataylor05/Terraform.Azure.Environment).

## Building the images
The project includes **azure-pipelines.yaml** files which is a pipeline as code file for use in Azure Devops, Azure Pipeline uses these files for pipeline definition.  A small catch to the azure-pipelines.yaml files and the initial build is that I build the docker images from this project on agents that are created from this project and that is reflected in the yaml files.  If you have not previously created a set of images then the azure-pipelines.yaml files need to be updated to use the Azure hosted agents.  After your first set of images exists the azure-pipelines.yaml files can be changed back to using custom agents for builds.

## Azure Devops Pre-Reqs
[ADO PAT](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=preview-page)<br>
[ADO Agent Pool](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/pools-queues?view=azure-devops&tabs=yaml%2Cbrowser)<br>
[Pipeline Task - Replace Tokens](https://marketplace.visualstudio.com/items?itemName=qetza.replacetokens)
