#!/bin/bash
#
#
#
#
az vm show --resource-group main_resources --name practica_vm 
az vm stop --resource-group main_resources --name practica_vm 

az aks show --name terraformk8s --resource-group main_resources
az aks stop --name terraformk8s --resource-group main_resources


#az vm show --resource-group main_resources --name practica_vm 
#az vm start --resource-group main_resources --name practica_vm 

#az aks show --name example-aks1 --resource-group main_resources
#az aks start --name example-aks1 --resource-group main_resources
#
 az vm list --query "[[?powerState=='VM running'].name, [?powerState=='VM running'].powerState]" -d -o table
 az aks show --name terraformk8s --resource-group main_resources --query 'agentPoolProfiles[0].powerState.code'
