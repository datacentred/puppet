# Class: dc_profile::foreman::foreman
#
# Provisions foreman with a database on another node
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::foreman::foreman {

  class { '::memcached':
    max_memory => 2048,
  }

  include ::foreman
  include ::foreman::plugin::discovery
  include ::foreman::plugin::digitalocean
  include ::foreman::plugin::hooks
  include ::foreman::plugin::puppetdb
  include ::dc_foreman::comms
  include ::dc_foreman::memcache
  include ::dc_icinga::hostgroup_https
  include ::dc_icinga::hostgroup_foreman

}
