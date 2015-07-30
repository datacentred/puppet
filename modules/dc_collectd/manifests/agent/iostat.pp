# == Class: dc_collectd::agent::iostat
#
class dc_collectd::agent::iostat {

  include ::dc_collectd::params

  File {
    owner => 'root',
    group => 'root',
  }

  # Make plugins directory structure
  file { [ $::dc_collectd::params::collectdlibs, $::dc_collectd::params::collectdpylibs ]:
    ensure  => directory,
    mode    => '0755',
    require => Package['collectd'],
  }

  file { "${::dc_collectd::params::collectdpylibs}/collectd_iostat_python.py":
    ensure => file,
    mode   => '0644',
    source => 'puppet:///modules/dc_collectd/collectd_iostat_python.py',
  }

  file { "${::dc_collectd::params::collectdconf}/10-iostat.conf":
    ensure => file,
    mode   => '0644',
    source => 'puppet:///modules/dc_collectd/10-iostat.conf',
    notify => Service['collectd'],
  }

}
