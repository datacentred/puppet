# == Class: dc_icinga2_plugins::base
#
#
class dc_icinga2_plugins::base {

  File {
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { [
    '/usr/local/lib/nagios',
    '/usr/local/lib/nagios/plugins',
  ]:
    ensure => directory,
  }

}
