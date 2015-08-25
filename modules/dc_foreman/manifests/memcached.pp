# == Class: dc_foreman::memcached
#
# Configures Foreman to use memcached
#
class dc_foreman::memcached {

  class { 'memcached':
    max_memory => '10%'
  }

  package { 'ruby-foreman-memcache':
    ensure => installed,
  }

  file { '/usr/share/foreman/config/settings.plugins.d/foreman_memcache.yaml':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => 'puppet:///modules/dc_foreman/foreman_memcache.yaml',
    notify  => Service['apache'],
  }

}
