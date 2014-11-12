# Class: dc_logstash::client
#
# Install and configure log-courier client for logstash
#
class dc_logstash::client (
  $logstash_server    = $dc_logstash::params::logstash_server,
  $logcourier_version = $dc_logstash::params::logcourier_version,
  $logcourier_port    = $dc_logstash::params::logcourier_port,
) inherits dc_logstash::params {

  file { '/usr/sbin/log-courier':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    source => "puppet:///modules/dc_logstash/log_courier/log-courier-${logcourier_version}",
  }

  file { '/etc/init.d/log-courier':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/dc_logstash/log_courier/log_courier.init',
  }

  file { '/etc/log-courier':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
  }

  file { '/var/lib/log-courier':
    ensure => directory,
    owner  => 'root',
    group  => 'root'
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
    require   => [ File['/usr/sbin/log-courier'], File['/etc/init.d/log-courier'] ],
    subscribe => Concat['/etc/log-courier/log-courier.conf'],
  }

}
