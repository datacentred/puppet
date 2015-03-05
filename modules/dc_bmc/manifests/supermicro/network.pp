# Class: dc_bmc::supermicro::network
#
# Configure the IPMI network interface
#
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
class dc_bmc::supermicro::network {

    exec { 'set_static':
      command => 'ipmitool lan set 1 ipsrc static',
      unless  => 'ipmitool lan print 1 | grep -w Source | cut -d \':\' -f 2 | grep Static >/dev/null',
      require => Package['ipmitool'],
    }

    # The space in the grep is deliberate in order to not match IP Address Source
    exec { 'set_ipmi_ip':
      command => "ipmitool lan set 1 ipaddr ${dc_bmc::bmc_ip}",
      unless  => "ipmitool lan print 1 | grep -w 'IP Address  ' | cut -d ':' -f 2 | grep -w '${dc_bmc::bmc_ip}' >/dev/null",
      require => Package['ipmitool'],
    }

    exec { 'set_ipmi_netmask':
      command => "ipmitool lan set 1 netmask ${dc_bmc::bmc_netmask}",
      unless  => "ipmitool lan print 1 | grep -w 'Subnet Mask' | cut -d ':' -f 2 | grep -w '${dc_bmc::bmc_netmask}' >/dev/null",
      require => Package['ipmitool'],
    }

    exec { 'set_ipmi_gateway':
      command => "ipmitool lan set defw ipaddr ${dc_bmc::bmc_gateway}",
      unless  => "ipmitool lan print 1 | grep -w 'Default Gateway IP' | cut -d ':' -f 2 | grep -w '${dc_bmc::bmc_gateway}' >/dev/null",
      require => Package['ipmitool'],
    }

}
