# Class: dc_profile::mon::nrpe
#
# Installs the Nagios remote procedure daemon
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::mon::nrpe {

  $icinga_ip = hiera(icinga_ip)

  class { 'dc_nrpe':
    allowed_hosts => "127.0.0.1 ${icinga_ip}/32",
  }

}
