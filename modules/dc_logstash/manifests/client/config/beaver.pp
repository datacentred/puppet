# Class: dc_logstash::client::config::beaver
#
# Install and configure beaver client for logstash
#
class dc_logstash::client::config::beaver {

  include ::dc_logstash::client

  $server = $::dc_logstash::client::server
  $api_version = $::dc_logstash::client::api_version
  $port = $::dc_logstash::client::port
  $key = $::dc_logstash::client::key
  $cert = $::dc_logstash::client::cert
  $cacert = $::dc_logstash::client::cacert
  $timeout = $::dc_logstash::client::timeout

  file { '/etc/beaver':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
  }

  file { '/var/log/beaver':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
  }

  file { '/etc/init.d/beaver':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/dc_logstash/beaver.init',
  }

  ensure_packages('python-pip')

  package { 'beaver':
    ensure          => installed,
    provider        => 'pip',
    require         => Package['python-pip'],
    install_options => ['>=34.0.1'],
  }

  concat { '/etc/beaver/beaver.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/etc/beaver'],
  }

  concat::fragment { 'beaver_header':
    target  => '/etc/beaver/beaver.conf',
    content => template('dc_logstash/client/beaver_client_header.erb'),
    order   => '01',
  }

  service { 'beaver':
    ensure    => running,
    enable    => true,
    require   => [ Package['beaver'], File['/etc/init.d/beaver'] ],
    subscribe => [ Concat['/etc/beaver/beaver.conf'], Package['beaver'] ],
  }

  logrotate::rule { 'beaver':
    path         => '/var/log/beaver/logstash_beaver.log',
    rotate       => 4,
    rotate_every => 'week',
    compress     => true,
  }

}
