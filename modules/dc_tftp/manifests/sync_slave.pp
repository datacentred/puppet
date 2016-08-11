# == Class: dc_tftp::sync_slave
#
# Installs an SSH user so lsyncd can synchronise the TFTP directory
#
class dc_tftp::sync_slave {

  assert_private()

  if ! $::dc_tftp::master {

    ssh_authorized_key { "${::dc_tftp::tftp_sync_user}@${::fqdn}":
      user => $::dc_tftp::tftp_sync_user,
      type => 'ssh-rsa',
      key  => $::dc_tftp::ssh_public_key,
    }

  }

}
