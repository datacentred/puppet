# Class: dc_foreman_proxy::bmc
#
# Foreman_proxy BMC configuration
#
# Parameters:
#
# Actions:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_foreman_proxy::bmc {

  package { 'rubyipmi':
    ensure   => installed,
    provider => gem,
  }

  ensure_packages(['ipmitool'])

}
