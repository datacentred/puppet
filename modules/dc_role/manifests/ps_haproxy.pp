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
class dc_role::ps_haproxy {

  contain dc_profile::net::ps_haproxy
  contain dc_profile::net::keepalived

}
