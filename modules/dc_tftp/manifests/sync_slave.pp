# Class: dc_tftp::sync_slave
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_tftp::sync_slave {

  include dc_tftp
  include dc_tftp::sync_user

  sshkeys::set_authorized_key {"${dc_tftp::tftp_sync_user}@${dc_tftp::sync_master} to ${dc_tftp::tftp_sync_user}@${::hostname}":
    local_user  => $dc_tftp::tftp_sync_user,
    remote_user => "${dc_tftp::tftp_sync_user}@${dc_tftp::sync_master}.${::domain}",
    home        => $dc_tftp::tftp_sync_home,
  }

}
