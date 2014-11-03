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

  Class['dc_profile::util::sysctls'] ->
  Class['dc_profile::net::loadbalancer']

}
