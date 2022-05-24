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

#######################################################################
## Create Hub and Spoke in WE and NE
#######################################################################
# resource "aviatrix_transit_gateway" "avx-hub-we-tg" {
#   account_name = "alweiss-internal"
#   cloud_type = 8

#   gw_name = "${var.reg1LocationShort}Tgw"
#   vpc_id = "avx-hub-${var.reg1LocationShort}-vn:${azurerm_resource_group.avx-lab-rg.name}:${data.aviatrix_vpc.avx-hub-we-vn-data.vpc_id}"
#   vpc_reg = var.reg1Location
#   gw_size = "Standard_B2ms"
#   subnet = "10.0.1.0/28"
# }

# resource "aviatrix_vpc" "avx-hub-we-vn" {
#   account_name = "alweiss-internal"
#   cloud_type = 8
#   name = "avx-hub-${var.reg1LocationShort}-vn"
#   resource_group = azurerm_resource_group.avx-lab-rg.name
#   cidr = "1.0.1.0/24"
#   region = var.reg1Location
#   subnet_size = "28"
#   num_of_subnet_pairs = "2"
# }

# data "aviatrix_vpc" "avx-hub-we-vn-data" {
#   name = aviatrix_vpc.avx-hub-we-vn.name
# }

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

resource "azurerm_virtual_network" "aztf-avx-hub-reg1-vn" {
  address_space = [ "10.0.1.0/24" ]
  location = var.reg1Location
  name = "aztf-avx-hub-${var.reg1LocationShort}-vn"
  resource_group_name = azurerm_resource_group.avx-lab-rg.name
  subnet {
    name  = "gw"
    address_prefix = "10.0.1.0/28"
  }
  subnet {
    name  = "vm"
    address_prefix = "10.0.1.16/28"
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
  }
  subnet {
    name  = "vm"
    address_prefix = "10.0.2.16/28"
  }
}

# resource "azurerm_virtual_network_peering" "hubReg1ToHubReg2" {
#   allow_forwarded_traffic = true
#   name = "hub-${var.reg1LocationShort}ToHub${var.reg2LocationShort}"
#   allow_virtual_network_access = true
#   resource_group_name = azurerm_resource_group.avx-lab-rg.name
#   virtual_network_name =   azurerm_virtual_network.aztf-avx-hub-reg1-vn.name
#   remote_virtual_network_id = azurerm_virtual_network.aztf-avx-hub-reg2-vn.id
# }

# resource "azurerm_virtual_network_peering" "hubReg2ToHubReg1" {
#   allow_forwarded_traffic = true
#   name = "hub-${var.reg2LocationShort}ToHub${var.reg1LocationShort}"
#   allow_virtual_network_access = true
#   resource_group_name = azurerm_resource_group.avx-lab-rg.name
#   virtual_network_name =   azurerm_virtual_network.aztf-avx-hub-reg2-vn.name
#   remote_virtual_network_id = azurerm_virtual_network.aztf-avx-hub-reg1-vn.id
# }

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

resource "aviatrix_transit_gateway_peering" "reg1-reg2-tp" {
  transit_gateway_name1 = aviatrix_transit_gateway.aztf-avx-hub-reg1-tg.gw_name
  transit_gateway_name2 = aviatrix_transit_gateway.aztf-avx-hub-reg2-tg.gw_name
}

resource "azurerm_virtual_network" "aztf-avx-spoke1-reg1-vn" {
  address_space = [ "10.0.3.0/24" ]
  location = var.reg1Location
  name = "aztf-avx-spoke1-${var.reg1LocationShort}-vn"
  resource_group_name = azurerm_resource_group.avx-lab-rg.name
  subnet {
    name  = "gw"
    address_prefix = "10.0.3.0/28"
  }
  subnet {
    name  = "vm"
    address_prefix = "10.0.3.16/28"
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
  }
  subnet {
    name  = "vm"
    address_prefix = "10.0.4.16/28"
  }
}

# resource "azurerm_virtual_network_peering" "hubReg1ToSpoke1" {
#   allow_forwarded_traffic = true
#   name = "hub-${var.reg1LocationShort}-to-spoke1-${var.reg1LocationShort}"
#   allow_virtual_network_access = true
#   resource_group_name = azurerm_resource_group.avx-lab-rg.name
#   virtual_network_name =   azurerm_virtual_network.aztf-avx-hub-reg1-vn.name
#   remote_virtual_network_id = azurerm_virtual_network.aztf-avx-spoke1-reg1-vn.id
# }

# resource "azurerm_virtual_network_peering" "spoke1ToHubReg1" {
#   allow_forwarded_traffic = true
#   name = "spoke1-${var.reg1LocationShort}-to-hub-${var.reg1LocationShort}"
#   allow_virtual_network_access = true
#   resource_group_name = azurerm_resource_group.avx-lab-rg.name
#   virtual_network_name =   azurerm_virtual_network.aztf-avx-spoke1-reg1-vn.name
#   remote_virtual_network_id = azurerm_virtual_network.aztf-avx-hub-reg1-vn.id
# }

# resource "azurerm_virtual_network_peering" "hubReg2ToSpoke2" {
#   allow_forwarded_traffic = true
#   name = "hub-${var.reg2LocationShort}-to-spoke2-${var.reg2LocationShort}"
#   allow_virtual_network_access = true
#   resource_group_name = azurerm_resource_group.avx-lab-rg.name
#   virtual_network_name =   azurerm_virtual_network.aztf-avx-hub-reg2-vn.name
#   remote_virtual_network_id = azurerm_virtual_network.aztf-avx-spoke2-reg2-vn.id
# }

# resource "azurerm_virtual_network_peering" "spoke2ToHubReg2" {
#   allow_forwarded_traffic = true
#   name = "spoke1-${var.reg2LocationShort}-to-hub-${var.reg2LocationShort}"
#   allow_virtual_network_access = true
#   resource_group_name = azurerm_resource_group.avx-lab-rg.name
#   virtual_network_name =   azurerm_virtual_network.aztf-avx-spoke2-reg2-vn.name
#   remote_virtual_network_id = azurerm_virtual_network.aztf-avx-hub-reg2-vn.id
# }

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