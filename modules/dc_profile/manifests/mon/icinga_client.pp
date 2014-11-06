# Class: dc_profile::mon::icinga_client
#
# Icinga client for all hosts on the network, bar the icinga server.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::mon::icinga_client {

  include ::dc_nrpe
  include ::dc_icinga::client

  Class['::dc_nrpe'] ->
  Class['::dc_icinga::client']

}
