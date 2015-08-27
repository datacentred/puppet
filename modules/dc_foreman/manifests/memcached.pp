# == Class: dc_foreman::memcached
#
# Configures Foreman to use memcached
#
class dc_foreman::memcached {

  service { 'memcached':
    ensure => stopped,
  } ->
  package { 'memcached':
    ensure => absent
  }

  package { 'ruby-foreman-memcache':
    ensure => absent,
  }

  file { '/usr/share/foreman/config/settings.plugins.d/foreman_memcache.yaml':
    ensure => absent,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/dc_foreman/foreman_memcache.yaml',
    notify => Service['httpd'],
  }

}
