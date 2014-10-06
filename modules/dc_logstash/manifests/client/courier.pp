# Class: dc_logstash::client::courier
#
# Install and configure log-courier
#
class dc_logstash::client::courier {

  $ls_host = hiera(logstash_server)
  $ls_courier_port = hiera(logstash_courier_port)

  file { '/usr/sbin/log-courier':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/dc_logstash/log_courier/log-courier',
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
    content => template('dc_logstash/log-courier_client_header.erb'),
    order   => '01',
  }

  concat::fragment { 'log_courier_footer':
    target  => '/etc/log-courier/log-courier.conf',
    content => template('dc_logstash/log-courier_client_footer.erb'),
    order   => '99',
  }

  service { 'log-courier':
    ensure    => running,
    enable    => true,
    require   => [ File['/usr/sbin/log-courier'], File['/etc/init.d/log-courier'] ],
    subscribe => Concat['/etc/log-courier/log-courier.conf'],
  }

}
