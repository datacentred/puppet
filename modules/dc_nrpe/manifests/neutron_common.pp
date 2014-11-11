# == Class: dc_nrpe::neutron_common
#
class dc_nrpe::neutron_common {

  include ::sudo
  include ::dc_profile::auth::sudoers_neutron

  file { '/etc/nagios/nrpe.d/neutron_common.cfg':
    ensure => present,
    source => 'puppet://modules/dc_nrpe/neutron_common.cfg',
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
  }

}
