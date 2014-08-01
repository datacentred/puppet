# Class:
#
# Creates the static host entries on the icinga server
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
class dc_icinga::server::static_hosts (
  $hostdefs,
){

  $defaults = {
    'ensure'  => 'present',
    'address' => get_ip_addr("${title}.${::domain}"),
    'use'     => 'dc_host_device'
  }

  create_resources('icinga::host', $hostdefs, $defaults)

  include dc_icinga::hostgroup_apcpdu

}
