subscriptions="subs-neo4j"

readarray -d "," -t all_subscriptions <<< "$subscriptions"

az account show
locations="centralus,northeurope,japaneast"
locations="japaneast"

readarray -d "," -t all_locations <<< "$locations"

username="tuser"
password="Neo4j@123456" # Replace with your desired password
vm_size="Standard_B2ms"
image="Canonical:0001-com-ubuntu-server-focal:20_04-lts:latest"

# Define the number of VMs to create

num_vms=5

for current_subscription in ${all_subscriptions[@]}
do
 echo "Working on Subscription: $current_subscription"
 az account set --subscription $current_subscription
 for location in ${all_locations[@]}
 do
  echo "Working on location: $location"
  resource_group="rg-neo4j-vms-$location"
  # echo az group create --name $resource_group --location $location
  az group create --name $resource_group --location $location
  for ((i=1; i<=$num_vms; i++)); do
      input="$current_subscription-$location-vm-$i"
      vm_subs=$(echo -n "$input" | sha512sum | tr '0-9' 'a-j' | tr -d '\n' | cut -c 1-$((64*10)) | grep -o . | awk '!seen[$0]++' | tr -d '\n'  | head -c 10)

      vm_name="$location-$vm_subs-$i"
      vm_dns_name="vm-$vm_subs-$i"

      echo "VM Name: $vm_name"
      echo "DNS Name: $vm_dns_name"

      # Create the VM
      az vm create --resource-group $resource_group --name $vm_name --image $image --admin-username $username --admin-password $password --location $location --size $vm_size --authentication-type password --storage-sku StandardSSD_LRS --public-ip-sku Basic --public-ip-address-allocation static --public-ip-address-dns-name $vm_dns_name --nsg '' --no-wait
  done
  
  #az vm list -o table

 done
done
