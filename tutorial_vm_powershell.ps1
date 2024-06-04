# Create resource group and location variables
$resourceGroup = "VMTutorialResources"
$location = "eastus"

# Create the resource group
az group create --name $resourceGroup --location $location

# Create Virtual network and subnet
$vnetName = "TutorialVNet1"
$subnetName = "TutorialSubnet1"
$vnetAddressPrefix = "10.0.0.0/16"
$subnetAddressPrefix = "10.0.1.0/24"

# Create a virtual network and subnet
az network vnet create --name $vnetName `
        --resource-group $resourceGroup `
        --address-prefixes $vnetAddressPrefix `
        --subnet-name $subnetName `
        --subnet-prefixes $subnetAddressPrefix

# Create PowerShell variable for the VM
$vmName = "TutorialVM1"
$adminUsername = "testuser7997"
$vmSize = "Standard_B1s"  # Specify the VM size
$scriptPath = "C:\Path\To\Your\kickstart.sh" # Path to your bash script

# Create the virtual Ubuntu 22.04 machine
az vm create `
        --resource-group $resourceGroup `
        --name $vmName `
        --admin-username $adminUsername `
        --image Ubuntu2204 `
        --vnet-name $vnetName `
        --subnet $subnetName `
        --generate-ssh-keys `
        --size $vmSize `
        --output json `
        --verbose

# Fetch the NIC ID
$nicId = $(az vm show `
                --name $vmName `
                --resource-group $resourceGroup `
                --query 'networkProfile.networkInterfaces[0].id' `
                --output tsv)

# Fetch the public IP ID
$ipId = $(az network nic show `
                --ids $nicId `
                --query 'ipConfigurations[0].publicIPAddress.id' `
                --output tsv)

# Fetch the public IP address
$vmIpAddress = $(az network public-ip show `
                --ids $ipId `
                --query 'ipAddress' `
                --output tsv)

# Output the VM's public IP address
Write-Output "The public IP address of the VM is: $vmIpAddress"

# Path to the private key file
$privateKeyPath = "$HOME\.ssh\id_rsa"

# Upload the script to the VM
Write-Output "Uploading script to the VM..."
scp -i $privateKeyPath $scriptPath $adminUsername@$vmIpAddress\:~/kickstart.sh

# Set the permissions for the script on the VM
Write-Output "Setting permissions for the script..."
ssh -i $privateKeyPath $adminUsername@$vmIpAddress "chmod +x ~/kickstart.sh"

# Execute the script on the VM
Write-Output "Executing the script on the VM..."
ssh -i $privateKeyPath $adminUsername@$vmIpAddress "~/kickstart.sh"
