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
  # TODO: this should probably have some deps and notifies between package
  #       and service will need testing when bringing up in CI
  # TODO: needs work on foreman to work properly - BRB!
  #include ::dc_foreman::ignored_environments
  include ::dc_foreman::comms
  include ::dc_foreman::memcache
  include ::dc_icinga::hostgroup_https
  include ::dc_icinga::hostgroup_foreman
  include ::apache::mod::status

}
