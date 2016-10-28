# == Class: dc_tftp::sync_user
#
# Installs the user account which will do synchronisation
#
class dc_tftp::sync_user {

  assert_private()

  group { $::dc_tftp::tftp_sync_group :
    ensure => present,
    system => true,
  }

  user { $::dc_tftp::tftp_sync_user :
    ensure     => present,
    home       => $::dc_tftp::tftp_sync_home,
    managehome => true,
    gid        => $::dc_tftp::tftp_sync_group,
    groups     => $::dc_tftp::tftp_group,
    system     => true,
    shell      => '/bin/bash',
  }

  passwordless_ssh { $::dc_tftp::tftp_sync_user:
    ssh_private_key => $::dc_tftp::ssh_private_key,
    ssh_public_key  => $::dc_tftp::ssh_public_key,
    home            => $::dc_tftp::tftp_sync_home,
  }

}
