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
class dc_role::icinga inherits dc_role {

  # Make the NSCA daemon  dependant on the icinga server as it requires the
  # nagios user to run
  contain dc_profile::mon::icinga_server
  contain dc_profile::mon::nsca_server

  Class['dc_profile::mon::icinga_server'] ->
  Class['dc_profile::mon::nsca_server']

}
