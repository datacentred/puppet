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
class dc_icinga::server {

  anchor { 'dc_icinga::server::first': } ->
  class { 'dc_icinga::server::install': } ->
  class { 'dc_icinga::server::config': } ->
  class { 'dc_icinga::server::service': } ->
  anchor { 'dc_icinga::server::last': }

}

