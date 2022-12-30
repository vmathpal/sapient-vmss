module "vnet" {
  #source  = "Azure/vnet/azurerm"
  source  = "./vnet"
  #version = "3.2.0"
  # insert the 2 required variables here
  vnet_name = "vnet-shared-hub-westeurope-001"
  resource_group_name = "rg-shared-westeurope-01"
  vnet_location = "westeurope"
  subnet_names = ["snet-management"]
  subnet_prefixes = ["10.0.1.0/24"]
}