# Class: dc_profile::mon::icinga_client
#
# Icinga client for all hosts on the network, bar the icinga server.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::mon::icinga_client {

  include dc_nrpe::install

  if $::environment == 'production' {
    $icinga_ip = hiera(icinga_ip)
    class { '::dc_nrpe':
      allowed_hosts => "127.0.0.1 ${icinga_ip}/32",
    } ->
    class { '::dc_icinga::client': }
  }

}
