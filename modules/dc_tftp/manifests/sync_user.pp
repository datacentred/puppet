# Class: dc_tftp::sync_user
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
class dc_tftp::sync_user {

  include dc_tftp

  user { $dc_tftp::tftp_sync_user :
    ensure     => present,
    home       => $dc_tftp::tftp_sync_home,
    managehome => true,
    gid        => $dc_tftp::tftp_sync_group,
    groups     => $dc_tftp::tftp_group,
    system     => true,
    shell      => '/bin/bash',
    require    => [ Class['::tftp'], Group[$dc_tftp::tftp_sync_group] ],
  }

  group { $dc_tftp::tftp_sync_group :
    ensure => present,
    system => true,
  }

}
