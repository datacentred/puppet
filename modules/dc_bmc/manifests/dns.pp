# Class: dc_bmc::dns
#
# Export a DNS entry for configured static addresses
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
class dc_bmc::dns {

  @@dns_resource { "${::hostname}-bmc.${::domain}/A":
      rdata => $dc_bmc::bmc_ip,
  }

}
