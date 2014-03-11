# Class: dc_logstash::forwarder
#
# Much like rsyslog, but does it encrpyted and compressed
#
class dc_logstash::forwarder (
  $ls_host = 'logstash',
  $ls_port = '55515',
) {

  package { 'logstash-forwarder':
    ensure => installed,
  }

  file { '/etc/logstash-forwarder':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dc_logstash/logstash-forwarder.erb'),
  }

  file { '/etc/ssl/certs/logstash-forwarder.crt':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/dc_logstash/logstash-forwarder.crt',
  }

  service { 'logstash-forwarder':
    ensure    => running,
    enable    => true,
    require   => Package['logstash-forwarder'],
    subscribe => [
      File['/etc/logstash-forwarder'],
      File['/etc/ssl/certs/logstash-forwarder.crt'],
    ],
  }

}
