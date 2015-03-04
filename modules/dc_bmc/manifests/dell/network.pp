# Class: dc_bmc::dell::network
#
# Configure DELL iDRAC networking
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_bmc::dell::network {

  # Disable DHCP
  drac_setting { 'cfgLanNetworking/cfgNicUseDhcp':
    object_value => 0,
  }

  # Set IP Address
  drac_setting { 'cfgLanNetworking/cfgNicIPAddress':
    object_value => $dc_bmc::bmc_ip,
  }

  # Set Mask
  drac_setting { 'cfgLanNetworking/cfgNicNetmask':
    object_value => '255.255.255.0',
  }

  # Set Gateway
  drac_setting { 'cfgLanNetworking/cfgNicGateway':
    object_value => $dc_bmc::bmc_gateway,
  }

  # Set Primary DNS
  drac_setting { 'cfgLanNetworking/cfgDNSServer1':
    object_value => $dc_bmc::prim_dns,
  }

  # Set Secondary DNS
  drac_setting { 'cfgLanNetworking/cfgDNSServer2':
    object_value => $dc_bmc::sec_dns,
  }

  # Set Domain
  drac_setting { 'cfgLanNetworking/cfgDNSDomainName':
    object_value => $::domain,
  }

  # set the hostname
  drac_setting { 'cfgLanNetworking/cfgDNSRacName':
    object_value => "${::hostname}-bmc",
  }

  # Set persistent PXE boot
  drac_setting { 'cfgServerInfo/cfgServerFirstBootDevice':
    object_value => 'PXE',
  }

  drac_setting { 'cfgServerInfo/cfgServerBootOnce':
    object_value => 0,
  }

  # Configure DNS
  drac_setting { 'cfgLanNetworking/cfgDNSDomainNameFromDHCP':
    object_value => 'Disabled',
  }

  drac_setting { 'cfgLanNetworking/cfgDNSServersFromDHCP':
    object_value => 'Disabled',
  }

  drac_setting { 'cfgIpmiLan/cfgIpmiLanEnable':
    object_value => 1
  }

  drac_setting { 'cfgIpmiLan/cfgIpmiLanPrivilegeLimit':
    object_value => 4
  }
}
