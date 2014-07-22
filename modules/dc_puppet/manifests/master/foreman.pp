# Class: dc_puppet::master::foreman
#
# Puppet master foreman manifest
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_puppet::master::foreman {

  class { 'dc_foreman_proxy':
    use_puppetca => true,
    use_puppet   => true,
    use_bmc      => false,
  }
  contain 'dc_foreman_proxy'

  contain dc_puppet::master::foreman::config

}

