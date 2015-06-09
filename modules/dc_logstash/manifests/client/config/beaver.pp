# Class: dc_logstash::client::config::beaver
#
# Install and configure beaver client for logstash
#
class dc_logstash::client::config::beaver (
  $logstash_server,
  $logstash_api_version,
  $logstash_beavertcp_port,
  $beaver_timeout,
) {

  # TODO: delete me
  include ::external_facts

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
    ensure   => installed,
    provider => 'pip',
    require  => Package['python-pip']
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

  # TODO: delete me
  external_facts::fact { 'log_shipper':
    value => 'beaver',
  }

}
