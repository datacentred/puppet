# Class: dc_logstash::client::config::log_courier
#
# Install and configure log-courier client for logstash
#
class dc_logstash::client::config::log_courier {

  include ::dc_logstash::client

  $version = $::dc_logstash::client::version
  $server = $::dc_logstash::client::server
  $port = $::dc_logstash::client::port
  $key = $::dc_logstash::client::key
  $cert = $::dc_logstash::client::cert
  $cacert = $::dc_logstash::client::cacert
  $timeout = $::dc_logstash::client::timeout

  package { 'log-courier':
    ensure  => '1.8.1-1~trusty1',
  }

  file { '/etc/log-courier':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  concat { '/etc/log-courier/log-courier.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/etc/log-courier'],
  }

  concat::fragment { 'log_courier_header':
    target  => '/etc/log-courier/log-courier.conf',
    content => template('dc_logstash/client/log-courier_client_header.erb'),
    order   => '01',
  }

  concat::fragment { 'log_courier_footer':
    target  => '/etc/log-courier/log-courier.conf',
    content => template('dc_logstash/client/log-courier_client_footer.erb'),
    order   => '99',
  }

  service { 'log-courier':
    ensure    => running,
    enable    => true,
    require   => Package['log-courier'],
    subscribe => [ Concat['/etc/log-courier/log-courier.conf'], Package['log-courier'] ],
  }

  logrotate::rule { 'log-courier':
    path         => '/var/log/log-courier.log',
    rotate       => 4,
    rotate_every => 'week',
    compress     => true,
  }

}
