# Create resource group and location variables
$resourceGroup = "VMTutorialResources"
$location = "eastus"

# Create Virtual network and subnet variables
$vnetName = "TutorialVNet1"
$subnetName = "TutorialSubnet1"
$vnetAddressPrefix = "10.0.0.0/16"
$subnetAddressPrefix = "10.0.1.0/24"

# Create PowerShell variable for the VM
$vmName = "TutorialVM1"
$adminUsername = "testuser7997"
$vmSize = "Standard_B1s"  # Specify the VM size

# Deleting the VM and Resource Group
Write-Output "Deleting virtual machine $vmName..."
az vm delete --resource-group $resourceGroup --name $vmName --yes --no-wait

# Verify that the VM was deleted
Write-Output "Verifying that the VM was deleted..."
az vm list --resource-group $resourceGroup --output table

# Delete the resource group
Write-Output "Deleting resource group $resourceGroup..."
az group delete --name $resourceGroup --yes --no-wait

# Verify that the resource group was deleted
Write-Output "Verifying that the resource group was deleted..."
az group list --output table
