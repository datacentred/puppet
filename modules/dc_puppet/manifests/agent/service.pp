# Class: dc_puppet::agent::service
#
# Puppet agent service
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_puppet::agent::service {

  include dc_puppet::params
  $dir = $dc_puppet::params::dir

  service { 'puppet':
    enable => false,
  }

  $times = ip_to_cron($dc_puppet::params::runinterval)

  cron { 'puppet':
    command => "/usr/bin/env puppet agent --config ${dir}/puppet.conf --onetime --no-daemonize",
    user    => 'root',
    hour    => $times[0],
    minute  => $times[1],
  }

}
