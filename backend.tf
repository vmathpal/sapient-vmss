terraform {
  backend "azurerm" {
    storage_account_name = "sapientassesnttfstatfile"
    container_name       = "statefile"
    key                  = "mystagetfstate"
    resource_group_name  = "rg-shared-westeurope-01"
  }
}

 