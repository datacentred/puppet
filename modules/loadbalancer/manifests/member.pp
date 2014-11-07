# == Class: loadbalancer::member
#
define loadbalancer::member (
  $ipaddresses,
  $ports,
  $options,
) {

  # NOTE: Yes it's a coding standard violation but a bug exists
  # somewhere with implicit type conversion
  @@haproxy::balancermember { $::fqdn:
    listening_service => $name,
    server_names      => $::hostname,
    ipaddresses       => $ipaddresses,
    ports             => "${ports}",
    options           => $options,
  }

}
