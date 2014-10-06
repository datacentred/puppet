# Class: dc_profile::net::haproxy
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
class dc_profile::net::haproxy_logstash (
  $listeners = {}
) {

  contain ::haproxy

  create_resources(haproxy::listen, $listeners)

}