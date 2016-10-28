# == Class: dc_tftp::sync_master
#
# Installs an lsyncd process to synchronise the TFTP directory
#
class dc_tftp::sync_master {

  assert_private()

  if $::dc_tftp::master {

    include ::lsyncd

    $_tftp_dir = $::dc_tftp::tftp_dir
    $_sync_slave = $::dc_tftp::sync_slave

    lsyncd::process { 'tftp':
      content => template($::dc_tftp::conf_template),
      owner   => $::dc_tftp::tftp_sync_user,
      group   => $::dc_tftp::tftp_sync_group,
    }

  }

}
