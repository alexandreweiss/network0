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
    controller_ip           = "xxxxxxxxxxxxxxxxxxxxx"
    username                = "xxxxxxxxxxxxxx"
    password                = "xxxxxxxxxxxxxx"
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

#######################################################################
## Create Hub and Spoke in WE and NE
#######################################################################
resource "aviatrix_transit_gateway" "avx-hub-we-vn" {
  account_name = "alweiss-internal"
  cloud_type = 8
  
  gw_name = "${var.reg1LocationShort}Tgw"
  vpc_id = "avx-hub-${var.reg1LocationShort}-vn:${azurerm_resource_group.avx-lab-rg.name}:${data.aviatrix_vpc.avx-hub-we-vn-data.vpc_id}"
  vpc_reg = var.reg1Location
  gw_size = "Standard_B2ms"
  subnet = "10.0.1.0/28"
}

resource "aviatrix_vpc" "avx-hub-we-vn" {
  account_name = "alweiss-internal"
  cloud_type = 8
  name = "avx-hub-${var.reg1LocationShort}-vn"
  resource_group = azurerm_resource_group.avx-lab-rg.name
  cidr = "1.0.1.0/24"
  region = var.reg1Location
}

data "aviatrix_vpc" "avx-hub-we-vn-data" {
  name = aviatrix_vpc.avx-hub-we-vn.name
}

# resource "aviatrix_vpc" "avx-spoke1-we-vn" {
#     cloud_type = 8
#     account_name = "alweiss-internal"
#     region = var.reg1Location
#     name = "avx-spoke1-${var.reg1LocationShort}-vn" 
#     cidr = "10.0.3.0/24"
#     aviatrix_firenet_vpc = false
#     # subnet {
#     #     cidr = "10.0.3.0/28"
#     #     name = "gw"
#     # }
#     # subnet {
#     #     cidr = "10.0.3.16/28"
#     #     name = "vm"
#     # }
#     resource_group = azurerm_resource_group.avx-lab-rg.name
# }

# resource "aviatrix_vpc" "avx-spoke2-we-vn" {
#     cloud_type = 8
#     account_name = "alweiss-internal"
#     region = var.reg2Location
#     name = "avx-spoke2-${var.reg1LocationShort}-vn" 
#     cidr = "10.0.4.0/24"
#     aviatrix_firenet_vpc = false
#     # subnet {
#     #     cidr = "10.0.4.0/28"
#     #     name = "gw"
#     # }
#     # subnet {
#     #     cidr = "10.0.4.16/28"
#     #     name = "vm"
#     # }
#     resource_group = azurerm_resource_group.avx-lab-rg.name
# }

# resource "aviatrix_transit_gateway" "avx-hub-ne-vn" {
#   account_name = "alweiss-internal"
#   cloud_type = 8
#   gw_name = "${var.reg2LocationShort}Tgw"
#   vpc_id = "avx-hub-${var.reg2LocationShort}-vn"
#   vpc_reg = var.reg2Location
#   gw_size = "Standard_B2ms"
#   subnet = "10.0.2.0/24"
# }

# resource "aviatrix_vpc" "avx-spoke1-ne-vn" {
#     cloud_type = 8
#     account_name = "alweiss-internal"
#     region = var.reg2Location
#     name = "avx-spoke1-${var.reg2LocationShort}-vn" 
#     cidr = "10.0.5.0/24"
#     aviatrix_firenet_vpc = false
#     resource_group = azurerm_resource_group.avx-lab-rg.name
# }

# resource "aviatrix_vpc" "avx-spoke2-ne-vn" {
#     cloud_type = 8
#     account_name = "alweiss-internal"
#     region = var.reg2Location
#     name = "avx-spoke2-${var.reg2LocationShort}-vn" 
#     cidr = "10.0.6.0/24"
#     aviatrix_firenet_vpc = false
#     resource_group = azurerm_resource_group.avx-lab-rg.name
# }

#######################################################################
## Create Peering WE HUB to Spoke 1 and 2
#######################################################################

# resource "aviatrix_azure_peer" "weHubWeSpoke1" {
#   account_name1 = "alweiss-internal"
#   account_name2 = "alweiss-internal"
#   vnet_name_resource_group1 = "${aviatrix_transit_vpc.avx-hub-ne-vn.}:${azurerm_resource_group.avx-lab-rg.name}"
#   vnet_name_resource_group2 = "${aviatrix_vpc.avx-spoke1-ne-vn.name}:${azurerm_resource_group.avx-lab-rg.name}"
#   vnet_reg1 = var.reg1Location
#   vnet_reg2 = var.reg1Location
# }

#######################################################################
## Create Peering NE HUB to Spoke 1 and 2
#######################################################################