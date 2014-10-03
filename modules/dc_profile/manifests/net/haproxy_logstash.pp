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
  $haproxy_hash,
) {

  include ::haproxy

  haproxy::listen { $haproxy_hash[ 'service_name' ] :
    ipaddress => $haproxy_hash[ 'listen_ip' ],
    mode      => $haproxy_hash[ 'mode' ],
    ports     => $haproxy_hash[ 'listen_ports' ],
  }

  Haproxy::Balancermember <<| |>>

}

