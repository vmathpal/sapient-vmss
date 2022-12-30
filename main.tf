provider "azurerm" {
  features {}
}

data "azurerm_log_analytics_workspace" "example" {
  name                = "log-analytics-wp"
  resource_group_name = "rg-shared-westeurope-01"
}

module "vmscaleset" {
  depends_on = [module.vnet, module.linuxservers]  
  source  = "kumarvna/vm-scale-sets/azurerm"
  #source   = "./vmscaleset"
  version = "2.3.0"

  resource_group_name  = "rg-shared-westeurope-01"
  virtual_network_name = "vnet-shared-hub-westeurope-001"
  subnet_name          = "snet-management"
  vmscaleset_name      = "testvmss"
  os_flavor               = "linux"
  linux_distribution_name = "ubuntu1804"
  virtual_machine_size    = "Standard_A2_v2"
  admin_username          = "vmathpal"
  admin_ssh_key_data      = "~/.ssh/id_rsa.pub"
  generate_admin_ssh_key  = true
  instances_count         = 2

  enable_proximity_placement_group    = true
  assign_public_ip_to_each_vm_in_vmss = true
  enable_automatic_instance_repair    = true

  load_balancer_type              = "public"
  load_balancer_health_probe_port = 80
  load_balanced_port_list         = [80, 443]
  additional_data_disks           = [100, 200]

      
  enable_autoscale_for_vmss          = true
  minimum_instances_count            = 2
  maximum_instances_count            = 5
  scale_out_cpu_percentage_threshold = 80
  scale_in_cpu_percentage_threshold  = 20

 
  enable_boot_diagnostics = true
  nsg_inbound_rules = [
    {
      name                   = "http"
      destination_port_range = "80"
      source_address_prefix  = "*"
    },

    {
      name                   = "https"
      destination_port_range = "443"
      source_address_prefix  = "*"
    },

    {
      name                   = "linuxaccess"
      destination_port_range = "22"
      source_address_prefix  = "210.16.95.159/32"
    },
  ]

   
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.example.id

  deploy_log_analytics_agent                 = true
  log_analytics_customer_id                  = data.azurerm_log_analytics_workspace.example.workspace_id
  log_analytics_workspace_primary_shared_key = data.azurerm_log_analytics_workspace.example.primary_shared_key


  tags = {
    ProjectName  = "Sapient-Assessment"
    Name          = "Vibhor Mathpal"
    Email        = "vmathpal1@gmail.com"
  }
}

output name {
  value       = module.vmscaleset.admin_ssh_key_private
  sensitive = true
}

