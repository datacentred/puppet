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

  concat { '/etc/logstash-forwarder':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644'
  }

  concat::fragment { 'logstash-forwarder-header':
    target  => '/etc/logstash-forwarder',
    content => template('dc_logstash/logstash-forwarder_client_header.erb'),
    order   => '01',
  }

  concat::fragment { 'logstash-forwarder-footer':
    target  => '/etc/logstash-forwarder',
    content => template('dc_logstash/logstash-forwarder_client_footer.erb'),
    order   => '99',
  }

  service { 'logstash-forwarder':
    ensure    => running,
    enable    => true,
    require   => Package['logstash-forwarder'],
    subscribe => Concat['/etc/logstash-forwarder'],
  }

}
