# Role for the icinga (nagios) server.  Make the NSCA daemon
# dependant on the icinga server as it requires the nagios
# user to run
class dc_role::platformservices_icinga {
  anchor { 'dc_role::platformservices_icinga::first': } ->
  # Make the NSCA daemon  dependant on the icinga server as it requires the
  # nagios user to run
  class { 'dc_profile::icinga_server': } ->
  class { 'dc_profile::nsca_server': } ->
  anchor { 'dc_role::platformservices_icinga::last': }
}
