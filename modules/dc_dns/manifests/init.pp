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
  $dns_zones = {},
  $masters = '',
) {

  include ::dns

  $defaults = {
    'nameservers' => $nameservers,
    'isslave'     => $isslave,
    'masters'     => $masters,
  }
  create_resources(dc_dns::dnszone, $dns_zones, $defaults)

}
