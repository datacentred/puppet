# Class: dc_profile::mon::nsca_client
#
# Installs the Nagios push client
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::mon::nsca_client {

  contain dc_nsca::client

}
