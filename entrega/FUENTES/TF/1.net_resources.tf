# https://azure.microsoft.com/es-mx/pricing/free-services

# 3. Create a resource group
resource "azurerm_resource_group" "recursos" {
  name     = var.gr_recursos[0]
  location = var.gr_recursos[1]
  tags = {
    Environment = "Test"
    Ceco = "UNIR"
  }
}

# 4. Create a virtual network within the resource group
resource "azurerm_virtual_network" "practica" {
  depends_on = [
   azurerm_resource_group.recursos
    ]
  name                = "practica-network"
  resource_group_name = var.gr_recursos[0]
  location            = var.gr_recursos[1]
  address_space       = var.vn_address
  tags = {
    Environment = "Test"
    Ceco = "UNIR"
  }
}

resource "azurerm_subnet" "frontend" {
  name                 = "frontend"
  virtual_network_name = azurerm_virtual_network.practica.name
  resource_group_name  = var.gr_recursos[0]
  address_prefixes     = var.vn_address_frontend
}

resource "azurerm_subnet" "backend" {
  name                 = "terraformsubnet"
  virtual_network_name = azurerm_virtual_network.practica.name
  resource_group_name  = var.gr_recursos[0]
  address_prefixes     = var.terraformsubnet
}

# resource "azurerm_network_watcher" "nwwatcher" {
#   name                = "nwwatcher"
#   location            = var.gr_recursos[1]
#   resource_group_name = var.gr_recursos[0]
# }

# Create public IP
resource   "azurerm_public_ip"   "publicip_1"   {
  depends_on = [
   azurerm_resource_group.recursos
    ]
   name   =   "pip1"
   location   =   var.gr_recursos[1]
   resource_group_name   =   var.gr_recursos[0]
   allocation_method   =  "Dynamic"
   sku   =   "Basic"
   tags = {
    Environment = "Test"
    Ceco = "UNIR"
  }
 }

 resource   "azurerm_network_interface"   "vm1nic"   {
   depends_on = [
    azurerm_public_ip.publicip_1
    ]
   name   =   "vm1-nic"
   location   =   var.gr_recursos[1]
   resource_group_name = var.gr_recursos[0]
   ip_configuration   {
     name   =   "ipconfig1"
     subnet_id   =   azurerm_subnet.backend.id
     private_ip_address_allocation   =  "Static"
     private_ip_address   = var.private_ip_address
     public_ip_address_id = azurerm_public_ip.publicip_1.id
   }
   tags = {
    Environment = "Test"
    Ceco = "UNIR"
  }
 }


 # Create Network Security Group and rule
resource "azurerm_network_security_group" "sgpractica2" {
  depends_on = [
   azurerm_network_interface.vm1nic
    ]

  name                = "sgpractica2"
  location            = var.gr_recursos[1]
  resource_group_name = var.gr_recursos[0]

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    description = " Entrante 22 ssh"
  }
   security_rule    {
    name                       = "https"
    priority                   = 1103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    description = " Por si he de entrar por https"
  }
    security_rule    {
    name                       = "http"
    priority                   = 1102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
     description = " Por si he de entrar por https"
  }
   security_rule    {
    name                       = "httpso"
    priority                   = 1104
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    description = " Por si he de salir saliente"
  }

}

# SecurityGroup2Network Interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.vm1nic.id
  network_security_group_id = azurerm_network_security_group.sgpractica2.id
}
