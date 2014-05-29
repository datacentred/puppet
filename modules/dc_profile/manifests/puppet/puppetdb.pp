# Class: dc_profile::puppet::puppetdb
#
# Provisions a puppetdb service node
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::puppet::puppetdb {

  $puppetdb_pw = hiera(puppetdb_pass)

  contain puppetdb::server

  file { '/etc/nagios/nrpe.d/puppetdb.cfg':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => 'command[check_puppetdb]=/usr/lib/nagios/plugins/check_http -H localhost -p 8080',
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
  }

  include dc_icinga::hostgroups
  realize External_facts::Fact['dc_hostgroup_puppetdb']

}

