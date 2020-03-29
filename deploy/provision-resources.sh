#!/bin/bash
# assumes 'az login' has been completed already

rg=$1
location=$2
planName=$3
sku=$4
webappName=$5
slotName=$6

subscriptionId=$(az account show --query "id" -o tsv)
echo "Using subscription ID $subscriptionId"

echo "Creating resource group $rg in $location"
az group create -l $location -n $rg
echo "Creating app service plan $planName with SKU $sku"
az appservice plan create -g $rg -n $planName --sku $sku
echo "Creating web app $webApp"
az webapp create -g $rg -p $plan -n $webapp