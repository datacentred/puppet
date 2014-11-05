# == Class: dc_elasticsearch::icinga
#
class dc_elasticsearch::icinga {

  file { '/usr/lib/nagios/plugins/es_data_updating_check':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/dc_elasticsearch/es_data_updating_check.rb'
  }

  include dc_icinga::hostgroup_http
  include dc_icinga::hostgroup_elasticsearch

}

