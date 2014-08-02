# Class: dc_icinga::server::gen_static_hosts
#
# Creates the static host entries on the icinga server
# Include any required hostgroups here also
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
class dc_icinga::server::gen_static_hosts (
  $hostdefs = {},
){

  create_resources('dc_icinga::static_host', $hostdefs)

  include dc_icinga::hostgroup_apcpdu

}
