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

  class { 'memcached':
    max_memory => 4096,
  }
  contain 'memcached'

  exported_vars::set { 'keystone_memcached':
    value => $::fqdn,
  }

}
