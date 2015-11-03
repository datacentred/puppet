# Class dc_foreman::memcache
class dc_foreman::memcache (
  $memcache_servers,
  $memcache_namespace,
  $memcache_compress,
  $memcache_expiry,
){

  package { 'ruby-foreman-memcache':
    ensure  => installed,
    require => File['/etc/foreman/plugins/foreman_memcache.yaml']
  }

  File {
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { '/etc/foreman/plugins/foreman_memcache.yaml':
    ensure  => file,
    content => template('dc_foreman/foreman_memcache.yml.erb'),
    require => Package['foreman'],
  }

}
