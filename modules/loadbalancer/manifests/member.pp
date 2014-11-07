# == Class: loadbalancer::member
#
define loadbalancer::member (
  $ipaddresses,
  $ports,
  $options,
) {

  @@haproxy::balancermember { $::fqdn:
    listening_service => $name,
    server_names      => $::hostname,
    ipaddresses       => $ipaddresses,
    ports             => $ports,
    options           => $options,
  }

}
