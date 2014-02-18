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

  $puppetdb_pw = hiera(puppetdb_pw)

  class { '::puppetdb::server':
    ssl_listen_address => '0.0.0.0',
    database           => 'postgres',
    database_host      => 'db0.sal01.datacentred.co.uk',
    database_name      => 'puppetdb',
    database_username  => 'puppetdb',
    database_password  => $puppetdb_pw,
  }

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
  realize Dc_external_facts::Fact['dc_hostgroup_puppetdb']

}

