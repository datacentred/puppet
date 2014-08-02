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

  include dc_icinga::hostgroup_apcpdu

  $defaults = {
    'ensure'  => 'present',
    'address' => get_ip_addr("${title}.${domain}"),
  }

  create_resources('icinga::host', $hostdefs, $defaults)

}
