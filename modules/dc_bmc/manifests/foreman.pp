# Class: dc_bmc::foreman
#
# Configures Foreman BMC integration
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
class dc_bmc::foreman {

  file { '/usr/local/bin/omapi_unset_ipmi.sh':
    ensure  => absent,
  }

  file { '/usr/local/bin/create_bmc_foreman.py':
    ensure  => absent,
  }

}
