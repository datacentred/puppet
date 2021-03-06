# Class:
#
# Top level icinga server class
#
# Parameters:
#
# Actions:
#
# Requires:
#
# dc_nrpe
#
# Sample Usage:
#
# class { 'dc_icinga::server': }
#
class dc_icinga::server (
  $pagerduty_api_key,
) {

  contain icinga::server
  contain dc_icinga::server::install
  contain dc_icinga::server::config
  contain dc_icinga::server::api
  contain dc_icinga::server::gen_static_hosts

}

