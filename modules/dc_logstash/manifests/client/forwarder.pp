# Class: dc_logstash::client::forwarder
#
# Much like rsyslog, but does it encrypted and compressed
#
class dc_logstash::client::forwarder {

  $ls_host = hiera(logstash_server)
  $ls_port = hiera(logstash_forwarder_port)

  package { 'logstash-forwarder':
    ensure => installed,
  }

  file { '/etc/logstash-forwarder':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dc_logstash/logstash-forwarder_client.erb'),
  }

  service { 'logstash-forwarder':
    ensure    => running,
    enable    => true,
    require   => Package['logstash-forwarder'],
    subscribe => File['/etc/logstash-forwarder'],
  }

}
