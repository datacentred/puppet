# == Class: dc_dns::forwarder_zone
#
# Wrapper for a DNS zone.  Sets up forwarder zones
#
define dc_dns::forwarder_zone (
  $forwarders = [],
) {

  dns::zone { $title:
    manage_file => false,
    zonetype    => 'forward',
    forward     => 'only',
    forwarders  => $forwarders,
  }
}
