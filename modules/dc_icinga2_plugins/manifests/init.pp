# == Class: dc_icinga2_plugins
#
# Installs and manages bespoke icinga/nagios plugins
#
class dc_icinga2_plugins {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0755',
  }

  file { [
    '/usr/local/lib/nagios',
    '/usr/local/lib/nagios/plugins',
  ]:
    ensure => directory,
  }

  file { '/usr/local/lib/nagios/plugins/check_bmc':
    ensure => file,
    source => 'puppet:///modules/dc_icinga2_plugins/check_bmc',
  }

  file { '/usr/local/lib/nagios/plugins/check_psu':
    ensure => file,
    source => 'puppet:///modules/dc_icinga2_plugins/check_psu',
  }

}
