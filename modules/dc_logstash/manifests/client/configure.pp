# == Class: dc_logstash::client::configure
#
# Configures the logstash client
#
class dc_logstash::client::configure {

  include dc_logstash::client

  $config = $dc_logstash::client::config

  file { '/etc/log-courier/log-courier.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => inline_template('<%= JSON.pretty_generate(@config) %>')
  }

  logrotate::rule { 'log-courier':
    path         => '/var/log/log-courier.log',
    rotate       => 4,
    rotate_every => 'week',
    compress     => true,
  }

}
