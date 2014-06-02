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

  include ::memcached

  class { 'memcached':
    max_memory => 4096,
  }

  exported_vars::set { 'keystone_memcached':
    value => $::fqdn,
  }

}
