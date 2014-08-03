# Class: dc_icinga::server::gen_static_hosts
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
class dc_icinga::server::gen_static_hosts (
  $hostdefs = {},
){

  create_resources('dc_icinga::server::static_host', $hostdefs)

}
