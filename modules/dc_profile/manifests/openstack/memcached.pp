# Class: dc_profile::openstack::memcached
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
class dc_profile::openstack::memcached {

  contain ::memcached

}
