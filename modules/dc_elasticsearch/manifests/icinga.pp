# == Class: dc_elasticsearch::icinga
#
class dc_elasticsearch::icinga {

  file { '/usr/local/sbin/es_data_updating_check':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/dc_elasticsearch/es_data_updating_check'
  }

  file { '/etc/nagios/nrpe.d/elasticsearch.cfg':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    source  => 'puppet:///modules/dc_elasticsearch/elasticsearch.cfg',
    require => Package['nagios-nrpe-server']
  }

  include dc_icinga::hostgroup_http
  include dc_icinga::hostgroup_elasticsearch

}

