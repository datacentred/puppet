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
) {

  $defaults = {
    'nameservers' => hiera(nameservers),
    'isslave'     => $isslave,
  }
  create_resources(dc_dns::dnszone, hiera(dns_zones), $defaults)

}
