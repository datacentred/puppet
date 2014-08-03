# Type: dc_icinga::server::static_host
#
# Wrapper for icinga::host so we can DNS lookups when using create_resource
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
#
define dc_icinga::server::static_host (
    $use        = 'dc_host_device',
    $hostgroups = undef,
    $address    = get_ip_addr("${title}.${::domain}"),
){

  icinga::host { $title :
    hostgroups => $hostgroups,
    use        => $use,
    address    => $address,
  }

}
