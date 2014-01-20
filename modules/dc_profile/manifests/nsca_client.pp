# Nagios NSCA client profile
class dc_profile::nsca_client {

  anchor { 'dc_profile::nsca_client::first': }
  ->
  class { 'dc_nsca::client': }
  ->
  anchor { 'dc_profile::nsca_client::last': }

}
