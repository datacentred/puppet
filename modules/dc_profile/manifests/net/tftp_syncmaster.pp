# Class: dc_profile::net::tftp_syncmaster
#
# Provide a TFTP server synchronised to a slave
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::net::tftp_syncmaster {

  include dc_tftp
  include dc_tftp::sync_master

}
