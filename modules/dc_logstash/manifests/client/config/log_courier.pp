# Class: dc_logstash::client::config::log_courier
#
# Install and configure log-courier client for logstash
#
class dc_logstash::client::config::log_courier {

  include ::dc_logstash::client

  $log_courier_config = $dc_logstash::client::log_courier_config

  package { 'log-courier':
    ensure => installed,
  } ->

  file { '/etc/log-courier/log-courier.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => inline_template('<%= JSON.pretty_generate(@log_courier_config) %>')
  } ~>

  service { 'log-courier':
    ensure => 'running',
  }

  logrotate::rule { 'log-courier':
    path         => '/var/log/log-courier.log',
    rotate       => 4,
    rotate_every => 'week',
    compress     => true,
  }

}
