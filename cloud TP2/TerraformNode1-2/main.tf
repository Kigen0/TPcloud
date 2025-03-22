terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "03fc03c9-6ad7-4bab-8c67-48f798c4b37d"
}

# Groupe de ressources
resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-rg"
  location = var.location
}

# Réseau virtuel
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
}

# Sous-réseau
resource "azurerm_subnet" "internal" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

# IP publique pour node1
resource "azurerm_public_ip" "node1" {
  name                = "${var.prefix}-node1-pip"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  allocation_method   = "Static"
}

# Interface réseau pour node1
resource "azurerm_network_interface" "node1" {
  name                = "${var.prefix}-nic-node1"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "node1-ipconfig"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.node1.id
  }
}

# Interface réseau pour node2
resource "azurerm_network_interface" "node2" {
  name                = "${var.prefix}-nic-node2"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "node2-ipconfig"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

# NSG pour autoriser SSH (port 22) et ping (ICMP via NSG = règle "AllowInternetOutbound" par défaut)
resource "azurerm_network_security_group" "ssh" {
  name                = "${var.prefix}-nsg-ssh"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # (optionnel) Autoriser ICMP (ping) → Azure n’autorise pas le protocole "ICMP" explicitement dans NSG
  # mais le ping fonctionne souvent dans le subnet privé
}

# Association NSG ↔ node1
resource "azurerm_network_interface_security_group_association" "node1" {
  network_interface_id      = azurerm_network_interface.node1.id
  network_security_group_id = azurerm_network_security_group.ssh.id
}

# Association NSG ↔ node2 (pas obligatoire si pas de SSH, mais bon, le ping passe via subnet privé)
resource "azurerm_network_interface_security_group_association" "node2" {
  network_interface_id      = azurerm_network_interface.node2.id
  network_security_group_id = azurerm_network_security_group.ssh.id
}

# VM node1
resource "azurerm_linux_virtual_machine" "node1" {
  name                  = "${var.prefix}-node1"
  resource_group_name   = azurerm_resource_group.main.name
  location              = var.location
  size                  = "Standard_B1s"
  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.node1.id]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("C:/Users/Nolac/.ssh/id_rsa.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

# VM node2
resource "azurerm_linux_virtual_machine" "node2" {
  name                  = "${var.prefix}-node2"
  resource_group_name   = azurerm_resource_group.main.name
  location              = var.location
  size                  = "Standard_B1s"
  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.node2.id]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("C:/Users/Nolac/.ssh/id_rsa.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}
