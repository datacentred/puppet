# Class: dc_role::ps_haproxy
#
# Role for setting up haproxy to support platform services
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::ps_haproxy inherits dc_role {

  include ::dc_profile::util::sysctls
  include ::dc_profile::net::loadbalancer
  include ::dc_ssl::haproxy
  include ::dc_icinga::hostgroup_haproxy

  Class['dc_profile::util::sysctls'] ->
  Class['dc_profile::net::loadbalancer']

}
