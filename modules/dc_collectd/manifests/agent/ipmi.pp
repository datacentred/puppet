# == Class: dc_collectd::agent::ipmi
#
class dc_collectd::agent::ipmi {

  include ::dc_collectd::params

  File {
    owner => 'root',
    group => 'root',
  }

  file { "${::dc_collectd::params::collectdconf}/10-ipmi.conf":
    ensure => file,
    mode   => '0644',
    source => 'puppet:///modules/dc_collectd/10-ipmi.conf',
    notify => Service['collectd'],
  }

}
