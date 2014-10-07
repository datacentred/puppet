# Class: dc_profile::net::ps_haproxy
#
# Configures haproxy
#
# Parameters:
#
# Actions:
#
# Requires: puppet-haproxy
#
# Sample Usage:
#
class dc_profile::net::ps_haproxy (
  $listeners = {}
) {

  contain ::haproxy

  create_resources(haproxy::listen, $listeners)

}
