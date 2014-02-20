# Class: dc_role::icinga
#
# Role for the icinga (nagios) server.  Make the NSCA daemon
# dependant on the icinga server as it requires the nagios
# user to run
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::icinga {

  # Make the NSCA daemon  dependant on the icinga server as it requires the
  # nagios user to run
  contain dc_profile::monitoring::icinga_server
  contain dc_profile::monitoring::nsca_server

  Class['dc_profile::monitoring::icinga_server'] ->
  Class['dc_profile::monitoring::nsca_server']

}
