# == Class: dc_icinga::server::custom_plugins
#
class dc_icinga::server::custom_plugins {

  # Custom nagios plugins directory
  file { '/usr/lib/nagios/plugins':
    ensure  => directory,
    source  => 'puppet:///modules/dc_icinga/custom_plugins',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    purge   => false,
    recurse => 'remote',
    require => Class['::icinga::client'],
  }

  sudo::conf { 'check_haproxy':
    priority => 10,
    content  => 'nagios ALL=NOPASSWD:/usr/lib/nagios/plugins/check_haproxy.rb',
  }

}
