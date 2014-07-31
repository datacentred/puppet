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
  $hostdefs = {}
){

  Icinga::Host {
    ensure  => present,
    alias   => "${title}.${::domain}",
    address => inline_template("<% _erbout.concat(Resolv::DNS.open.getaddress('${title}').to_s) %>"),
  }

  create_resources('icinga::host', $hostdefs)

  include dc_icinga::hostgroup_apcpdu

}
