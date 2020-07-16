
provider "azurerm" {
  #version= "=2.17.0"
  features {}
}

#------------------------- Resouorce Group ------------------
resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = var.location
}

#---------------------------Vnet-----------------------------
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
}
#----------------------- Subnet ----------------------------
resource "azurerm_subnet" "internal" {
  name                 = "${var.prefix}-subinternal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}
#--------------------------NSG------------------------------
resource "azurerm_network_security_group" "nsg" {
    name = "${var.prefix}-nsg"
    location = var.location
    resource_group_name = azurerm_resource_group.main.name
    security_rule {
      name = "SSH"
      priority = 1001
      direction = "Inbound"
      access = "Allow"
      protocol = "Tcp"
      source_port_range = "*"
      destination_port_range = "22"
      source_address_prefix =  "194.204.217.78"
      destination_address_prefix = "*"

    }

}

#-----------------------------Public IP ----------------------
  resource "azurerm_public_ip" "pubip" {
    resource_group_name = azurerm_resource_group.main.name
    name = "${var.prefix}-public_ip"
    location = var.location
    allocation_method = "Dynamic"
  }

#------------------------------Network interface -------------
resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location

  ip_configuration {
    name                          = "${var.prefix}-ipconfig"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.2.100"
    public_ip_address_id = azurerm_public_ip.pubip.id
  }
}
#------------------------Assign NSG to nic ------------------------------------
resource "azurerm_network_interface_security_group_association"  "nsg-to-nic" {
    network_interface_id = azurerm_network_interface.main.id
    network_security_group_id = azurerm_network_security_group.nsg.id

  }


# ----------------------------- Linux Centos VM --------------------------------
resource "azurerm_linux_virtual_machine" "centosvm" {
  name                            = "${var.prefix}-centos-vm"
  computer_name                   = var.computer_name
  resource_group_name             = azurerm_resource_group.main.name
  location                        = var.location
  size                            = "Standard_DS1_v2"
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids = [azurerm_network_interface.main.id]

  
    os_disk {
      name = "${var.prefix}-vm_OsDisk"
      caching = "ReadWrite"
      storage_account_type = "Premium_LRS"
    }

    source_image_reference {
      publisher = "OpenLogic"
      offer =  "CentOS"
      sku = "7.5"
      version = "latest"
    }

}
# ----------------------------- CustomScript --------------------------------

resource "azurerm_virtual_machine_extension" "vm-install-softs" {
  name                 = var.computer_name
  virtual_machine_id   = azurerm_linux_virtual_machine.centosvm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
      
        "fileUris": ["https://raw.githubusercontent.com/hyscham/terraform/master/deploy.sh"],
        "commandToExecute": "sh deploy.sh"
    }
SETTINGS
}
# ----------------------------- Provisioner --------------------------------
    #Connect to Ssh
    #Os Update
    #Firewall config or disable
    #Selinux disable
    #Create Folder
      #Download Elastic Tar
      #Config file
      #Download Kibana Tar
      #Config File
      #Download Or online install penDistro Alerte Module
      #Rsyslog
      #FluentD

#--------------------------------------------------------------------------
/*      provisioner "remote-exec" {
        connection {
            host     = self.public_ip_address
            user     = var.admin_username
            password = var.admin_password
            port = 22  
            timeout =  "1m" 
            agent = true
          }

          inline = [
            "sudo yum update",
            "sudo yum install curl wget",
            "sudo mkdir /opt/efk_repos",
            "cd /opt/efk_repos",
            "curl -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-7.7.0-linux-x86_64.tar.gz",
            "tar -xzf elasticsearch-oss-7.7.0-linux-x86_64.tar.gz",
            "mv elasticsearch-oss-7.7.0-linux-x86_64 elasticsearch",
            "curl -O https://artifacts.elastic.co/downloads/kibana/kibana-oss-7.7.0-linux-x86_64.tar.gz",
            "tar -xzf kibana-oss-7.7.0-linux-x86_64.tar.gz",
            "mv kibana-oss-7.7.0-linux-x86_64 kibana",
            "cd elasticsearch",
            "sudo bin/elasticsearch-plugin install https://d3g5vo6xdbdb9a.cloudfront.net/downloads/elasticsearch-plugins/opendistro-job-scheduler/opendistro-job-scheduler-1.8.0.0.zip",
            "sudo bin/elasticsearch-plugin install https://d3g5vo6xdbdb9a.cloudfront.net/downloads/elasticsearch-plugins/opendistro-alerting/opendistro_alerting-1.8.0.0.zip",
            "cd ../kibana",
            "sudo bin/kibana-plugin install https://d3g5vo6xdbdb9a.cloudfront.net/downloads/kibana-plugins/opendistro-alerting/opendistro-alerting-1.8.0.0.zip",
          ]

          
        }
  */      




