# == Class: dc_nrpe::configure
#
class dc_nrpe::configure {

  file { '/etc/nagios/nrpe.cfg':
    ensure => file,
    path   => '/etc/nagios/nrpe.cfg',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/dc_nrpe/nrpe.cfg',
  }

  file { '/etc/nagios/nrpe.d':
    ensure  => directory,
    recurse => true,
    purge   => true,
  }

  concat { '/etc/nagios/nrpe.d/dc_nrpe_check.cfg':
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  include ::dc_nrpe::checks::ceilometer_compute
  include ::dc_nrpe::checks::ceilometer_oscontrol
  include ::dc_nrpe::checks::ceph
  include ::dc_nrpe::checks::cinder
  include ::dc_nrpe::checks::common
  include ::dc_nrpe::checks::glance
  include ::dc_nrpe::checks::hpblade
  include ::dc_nrpe::checks::logstash
  include ::dc_nrpe::checks::logstash_server
  include ::dc_nrpe::checks::lsyncd
  include ::dc_nrpe::checks::neutron
  include ::dc_nrpe::checks::neutron_agent
  include ::dc_nrpe::checks::neutron_common
  include ::dc_nrpe::checks::nova_compute
  include ::dc_nrpe::checks::nova_server
  include ::dc_nrpe::checks::postfix
  include ::dc_nrpe::checks::postgres
  include ::dc_nrpe::checks::puppetdb
  include ::dc_nrpe::checks::sensors
  include ::dc_nrpe::checks::smartd
  include ::dc_nrpe::checks::check_hw
  include ::dc_nrpe::checks::net_interfaces
  include ::dc_nrpe::checks::supermicro_psu_ipmi
  include ::dc_nrpe::checks::foreman_interfaces
  include ::dc_nrpe::checks::disk_stats

}
