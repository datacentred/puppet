# Class: dc_logstash::config::input_forwarder
#
# Server side configuration for forwarder input
#
class dc_logstash::config::input_forwarder {

  $forwarder_conf_path = '/etc/logstash/logstash-forwarder'
  $keypath = "${forwarder_conf_path}/logstash-forwarder.key"
  $certpath = "${forwarder_conf_path}/logstash-forwarder.crt"

  file { $forwarder_conf_path:
    ensure => directory,
    owner  => 'logstash',
    group  => 'logstash',
    mode   => '0600'
  }

  file { $keypath:
    ensure  => file,
    owner   => 'logstash',
    group   => 'logstash',
    mode    => '0600',
    source  => 'puppet:///modules/dc_logstash/logstash-forwarder.key',
    require => File[$forwarder_conf_path],
  }

  file { $certpath:
    ensure  => file,
    owner   => 'logstash',
    group   => 'logstash',
    mode    => '0600',
    source  => 'puppet:///modules/dc_logstash/logstash-forwarder.crt',
    require => File[$forwarder_conf_path],
  }

  logstash::configfile { 'input_forwarder':
    content => template('dc_logstash/input_forwarder.erb'),
    order   => '11',
  }
}
