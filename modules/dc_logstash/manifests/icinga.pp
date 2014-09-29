# == Class: dc_logstash::icinga
#
class dc_logstash::icinga {

  file { '/usr/local/sbin/es_data_updating_check':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/dc_logstash/es_data_updating_check'
  }

  file { '/etc/nagios/nrpe.d/logstashes.cfg':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    source  => 'puppet:///modules/dc_logstash/logstashes.cfg',
    require => Package['nagios-nrpe-server']
  }

  include dc_icinga::hostgroup_http
  include dc_icinga::hostgroup_logstashes

}

