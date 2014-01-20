# Nagios NSCA client profile
class dc_profile::nsca_server {

  anchor { 'dc_profile::nsca_server::first': }
  ->
  class { 'dc_nsca::server': }
  ->
  anchor { 'dc_profile::nsca_server::last': }

}
