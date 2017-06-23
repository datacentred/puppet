# Class: dc_profile::log::logstash
#
# Basic class for installing Logstash and subsequent configuration
# for parsing events fed via rsyslog from other hosts.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::log::logstash {

  include ::dc_logstash::server

  include ::dc_icinga::hostgroup_http

  cron { 'geoip_data_update':
    command  => '/usr/bin/geoipupdate',
    user     => 'root',
    monthday => 15,
  }

  ensure_packages('geoipupdate')

  Package['geoipupdate'] ->

  file { '/etc/GeoIP.conf':
    ensure => present,
    source => 'puppet:///modules/dc_profile/GeoIP.conf',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }
}
