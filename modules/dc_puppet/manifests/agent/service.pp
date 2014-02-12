#
class dc_puppet::agent::service {
  include dc_puppet::params

  service { 'puppet':
    ensure => stopped,
  }

  $times = ip_to_cron($dc_puppet::params::runinterval)

  cron { 'puppet':
    command => '/usr/bin/env puppet agent --config /etc/puppet/puppet.conf --onetime --no-daemonize',
    user    => 'root',
    hour    => $times[0],
    minute  => $times[1],
  }
}
