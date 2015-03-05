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

  # enable DHCP
  drac_setting { 'cfgLanNetworking/cfgNicUseDhcp':
    object_value => 1,
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
    object_value => 'Enabled',
  }

  drac_setting { 'cfgLanNetworking/cfgDNSServersFromDHCP':
    object_value => 'Enabled',
  }

  drac_setting { 'cfgIpmiLan/cfgIpmiLanEnable':
    object_value => 1
  }

  drac_setting { 'cfgIpmiLan/cfgIpmiLanPrivilegeLimit':
    object_value => 4
  }
}
