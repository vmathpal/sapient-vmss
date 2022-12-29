resource "azurerm_resource_group" "example" {
  name     = "rg-devops"
  location = "westeurope"
}

data "template_file" "ansible_install" {
    template = file("~/jenkins/ansible.sh")
}

module "linuxservers" {
  depends_on = [resource.azurerm_resource_group.example]
  #source                           = "Azure/compute/azurerm"
  source                           = "module/linuxservers"
  resource_group_name              = azurerm_resource_group.example.name
  vm_hostname                      = "mylinuxvm"
  nb_public_ip                     = 1
  remote_port                      = "22"
  nb_instances                     = 1
  vm_os_publisher                  = "OpenLogic"
  vm_os_offer                      = "CentOS-CI"
  vm_os_sku                        = "7-CI"
  vnet_subnet_id                   = module.vnet.vnet_subnets[0]
  boot_diagnostics                 = true
  delete_os_disk_on_termination    = true
  nb_data_disk                     = 1
  data_disk_size_gb                = 16
  data_sa_type                     = "Premium_LRS"
  enable_ssh_key                   = true
  admin_username                   = "vmathpal"
  ssh_key                          = "~/.ssh/id_rsa.pub"  
  vm_size                          = "Standard_D2s_v3"
  custom_data                      = base64encode(data.template_file.ansible_install.rendered)
  delete_data_disks_on_termination = true

  tags = {
    environment = "dev"
    costcenter  = "it"
  }

  enable_accelerated_networking = true
}

output "linux_vm_public_ip_addr" {
  value = module.linuxservers.public_ip_address
}
