# == Class: dc_dns
#
# DNS zone definitions
#
# === Parameters
#
# [*masters*]
#   If masters is set then this node is a DNS slave and will pull
#   IXFR records from the DNS master.
#
class dc_dns (
  $masters = [],
) {

  include ::dns

  $zones = hiera_hash('dc_dns::zones')

  $defaults = {
    'masters' => $masters,
  }

  create_resources('dc_dns::zone', $zones, $defaults)

}
