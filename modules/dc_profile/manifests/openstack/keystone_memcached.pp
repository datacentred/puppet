# Class: dc_profile::openstack::keystone_memcached
#
# Install memcached for use with keystone (auth token storage)
#
# Parameters:
#
# Actions:
#
# Requires: memcached
#
# Sample Usage:
#
class dc_profile::openstack::keystone_memcached {

  $memcached_port = '11211'

  class { 'memcached':
    max_memory => 4096,
    tcp_listen => $memcached_port,
    udp_listen => $memcached_port,
    logfile    => '/var/log/memcached_keystone.log'
  }
  contain 'memcached'

  exported_vars::set { 'keystone_memcached':
    value => "${::fqdn}:${memcached_port}",
  }

}
