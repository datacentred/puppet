# Class:
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
class dc_profile::icinga_client {

  $nrpe_hosts = hiera(nrpe_hosts)
  $nrpe_commands = hiera(nrpe_commands)

  class { '::dc_nrpe':
    allowed_hosts => $nrpe_hosts,
    nrpe_commands => $nrpe_commands,
  } ->
  class { '::dc_icinga::client': }

}

