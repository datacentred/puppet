# Class: dc_dns
#
# DNS zone definitions
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_dns (
  $isslave = false,
  $nameservers = {},
  $masters = '',
) {

  include ::dns

  $dns_zones = hiera_hash('dc_dns::dns_zones')

  $defaults = {
    'nameservers' => $nameservers,
    'isslave'     => $isslave,
    'masters'     => $masters,
  }
  create_resources(dc_dns::dnszone, $dns_zones, $defaults)

}
