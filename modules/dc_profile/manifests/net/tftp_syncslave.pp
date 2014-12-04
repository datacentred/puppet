# Class: dc_profile::net::tftp_syncslave
#
# Provide a TFTP failover server synchronised to a master
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::net::tftp_syncslave {

  include dc_tftp
  include dc_tftp::sync_slave

}
