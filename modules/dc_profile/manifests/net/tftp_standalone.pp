# Class: dc_profile::net::tftp_standalone
#
# Provide a TFTP server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::net::tftp_standalone {

  class { 'dc_tftp' :
    ha_sync => false,
  }

}
