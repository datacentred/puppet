# == Class: ::dc_profile::net::unifi
#
class dc_profile::net::unifi (
  Hash $fwrules,
  ) {
  include ::firewall

  create_resources(firewall, $fwrules['base'])
}
