# Class: dc_profile::mon::nsca_client
#
# Installs the Nagios push server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::mon::nsca_server {

  contain dc_nsca::server

}
