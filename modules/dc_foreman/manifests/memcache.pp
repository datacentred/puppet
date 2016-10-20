# == Class: dc_foreman::memcache
#
# Configure Foreman to use memcached
#
class dc_foreman::memcache {

  $memcache_servers = $dc_foreman::memcache_servers
  $memcache_namespace = $dc_foreman::memcache_namespace
  $memcache_compress = $dc_foreman::memcache_compress
  $memcache_expiry = $dc_foreman::memcache_expiry

  Class['::foreman::install'] ->

  file { '/etc/foreman/plugins/foreman_memcache.yaml':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dc_foreman/foreman_memcache.yml.erb'),
  } ->

  package { 'ruby-foreman-memcache':
    ensure  => installed,
  }

}
