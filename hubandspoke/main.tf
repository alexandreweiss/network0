terraform {
  required_providers {
    aviatrix = {
      source = "AviatrixSystems/aviatrix"
      version = "2.22.0"
    }
  }
}

provider "azurerm" {
    features {
    }
}


provider "aviatrix" {
    controller_ip           = var.ctlIP
    username                = var.ctlAdmin
    password                = var.ctlAdminPwd
    skip_version_validation = false
    verify_ssl_certificate  = false
}

#######################################################################
## Create Resource Group
#######################################################################

resource "azurerm_resource_group" "avx-lab-rg" {
  name     = "avx-lab-4"
  location = var.reg1Location
 tags = {
    environment = "avx"
  }
}

#######################################
# Azure Hub Virtual Networks
#######################################

resource "azurerm_virtual_network" "aztf-avx-hub-reg1-vn" {
  address_space = [ "10.0.1.0/24" ]
  location = var.reg1Location
  name = "aztf-avx-hub-${var.reg1LocationShort}-vn"
  resource_group_name = azurerm_resource_group.avx-lab-rg.name
  subnet {
    name  = "gw"
    address_prefix = "10.0.1.0/28"
    security_group = azurerm_network_security_group.aztf-avx-hub-reg1-nsg.id
  }
  subnet {
    name  = "vm"
    address_prefix = "10.0.1.16/28"
    security_group = azurerm_network_security_group.aztf-avx-hub-reg1-nsg.id
  }
}

resource "azurerm_network_security_group" "aztf-avx-hub-reg1-nsg" {
  name = "aztf-avx-hub-${var.reg1LocationShort}-nsg"
  resource_group_name = azurerm_resource_group.avx-lab-rg.name
  location = var.reg1Location
  security_rule {
    name                       = "Any"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_virtual_network" "aztf-avx-hub-reg2-vn" {
  address_space = [ "10.0.2.0/24" ]
  location = var.reg2Location
  name = "aztf-avx-hub-${var.reg2LocationShort}-vn"
  resource_group_name = azurerm_resource_group.avx-lab-rg.name
  subnet {
    name  = "gw"
    address_prefix = "10.0.2.0/28"
    security_group = azurerm_network_security_group.aztf-avx-hub-reg2-nsg.id
  }
  subnet {
    name  = "vm"
    address_prefix = "10.0.2.16/28"
    security_group = azurerm_network_security_group.aztf-avx-hub-reg2-nsg.id
  }
}

resource "azurerm_network_security_group" "aztf-avx-hub-reg2-nsg" {
  name = "aztf-avx-hub-${var.reg2LocationShort}-nsg"
  resource_group_name = azurerm_resource_group.avx-lab-rg.name
  location = var.reg2Location
  security_rule {
    name                       = "Any"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

#######################################
# Aviatrix Transit Gateways
#######################################

resource "aviatrix_transit_gateway" "aztf-avx-hub-reg1-tg" {
  account_name = "alweiss-internal"
  cloud_type = 8
  gw_name = "${var.reg1LocationShort}-tg"
  vpc_id = "aztf-avx-hub-${var.reg1LocationShort}-vn:${azurerm_resource_group.avx-lab-rg.name}:${azurerm_virtual_network.aztf-avx-hub-reg1-vn.guid}"
  vpc_reg = var.reg1Location
  gw_size = "Standard_B2ms"
  subnet = "10.0.1.0/28"
}

resource "aviatrix_transit_gateway" "aztf-avx-hub-reg2-tg" {
  account_name = "alweiss-internal"
  cloud_type = 8
  gw_name = "${var.reg2LocationShort}-tg"
  vpc_id = "aztf-avx-hub-${var.reg2LocationShort}-vn:${azurerm_resource_group.avx-lab-rg.name}:${azurerm_virtual_network.aztf-avx-hub-reg2-vn.guid}"
  vpc_reg = var.reg2Location
  gw_size = "Standard_B2ms"
  subnet = "10.0.2.0/28"
}

#######################################
# Aviatrix Inter Region transit peering
#######################################

resource "aviatrix_transit_gateway_peering" "reg1-reg2-tp" {
  transit_gateway_name1 = aviatrix_transit_gateway.aztf-avx-hub-reg1-tg.gw_name
  transit_gateway_name2 = aviatrix_transit_gateway.aztf-avx-hub-reg2-tg.gw_name
}

#######################################
# Azure Spoke Virtual Networks
#######################################

resource "azurerm_virtual_network" "aztf-avx-spoke1-reg1-vn" {
  address_space = [ "10.0.3.0/24" ]
  location = var.reg1Location
  name = "aztf-avx-spoke1-${var.reg1LocationShort}-vn"
  resource_group_name = azurerm_resource_group.avx-lab-rg.name
  subnet {
    name  = "gw"
    address_prefix = "10.0.3.0/28"
    security_group = azurerm_network_security_group.aztf-avx-spoke1-reg1-nsg.id
  }
  subnet {
    name  = "vm"
    address_prefix = "10.0.3.16/28"
    security_group = azurerm_network_security_group.aztf-avx-spoke1-reg1-nsg.id
  }
}

resource "azurerm_network_security_group" "aztf-avx-spoke1-reg1-nsg" {
  name = "aztf-avx-spoke1-${var.reg1LocationShort}-nsg"
  resource_group_name = azurerm_resource_group.avx-lab-rg.name
  location = var.reg1Location
  security_rule {
    name                       = "Any"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_virtual_network" "aztf-avx-spoke2-reg2-vn" {
  address_space = [ "10.0.4.0/24" ]
  location = var.reg2Location
  name = "aztf-avx-spoke2-${var.reg2LocationShort}-vn"
  resource_group_name = azurerm_resource_group.avx-lab-rg.name
  subnet {
    name  = "gw"
    address_prefix = "10.0.4.0/28"
    security_group = azurerm_network_security_group.aztf-avx-spoke2-reg2-nsg.id
  }
  subnet {
    name  = "vm"
    address_prefix = "10.0.4.16/28"
    security_group = azurerm_network_security_group.aztf-avx-spoke2-reg2-nsg.id
  }
}

resource "azurerm_network_security_group" "aztf-avx-spoke2-reg2-nsg" {
  name = "aztf-avx-spoke2-${var.reg2LocationShort}-nsg"
  resource_group_name = azurerm_resource_group.avx-lab-rg.name
  location = var.reg2Location
  security_rule {
    name                       = "Any"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

#######################################
# Aviatrix Spoke Gateways
#######################################

resource "aviatrix_spoke_gateway" "aztf-avx-spoke1-reg1-tg" {
  account_name = "alweiss-internal"
  cloud_type = 8
  gw_name = "${var.reg1LocationShort}-spoke1-tg"
  vpc_id = "aztf-avx-spoke1-${var.reg1LocationShort}-vn:${azurerm_resource_group.avx-lab-rg.name}:${azurerm_virtual_network.aztf-avx-spoke1-reg1-vn.guid}"
  vpc_reg = var.reg1Location
  gw_size = "Standard_B2ms"
  subnet = "10.0.3.0/28"
}

resource "aviatrix_spoke_gateway" "aztf-avx-spoke2-reg2-tg" {
  account_name = "alweiss-internal"
  cloud_type = 8
  gw_name = "${var.reg2LocationShort}-spoke2-tg"
  vpc_id = "aztf-avx-spoke2-${var.reg2LocationShort}-vn:${azurerm_resource_group.avx-lab-rg.name}:${azurerm_virtual_network.aztf-avx-spoke2-reg2-vn.guid}"
  vpc_reg = var.reg2Location
  gw_size = "Standard_B2ms"
  subnet = "10.0.4.0/28"
}