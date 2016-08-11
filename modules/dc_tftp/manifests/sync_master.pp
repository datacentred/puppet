# == Class: dc_tftp::sync_master
#
# Installs an lsyncd process to synchronise the TFTP directory
#
class dc_tftp::sync_master {

  assert_private()

  if $::dc_tftp::master {

    include ::lsyncd

    $_tftp_dir = $::dc_tftp::tftp_dir
    $_tftp_sync_user = $::dc_tftp::tftp_sync_user
    $_tftp_sync_group = $::dc_tftp::tftp_sync_group
    $_tftp_sync_home = $::dc_tftp::tftp_sync_home
    $_sync_slave = $::dc_tftp::sync_slave

    file { "${_tftp_sync_home}/.ssh":
      ensure => directory,
      owner  => $_tftp_sync_user,
      group  => $_tftp_sync_group,
      mode   => '0700',
    } ->

    file { "${_tftp_sync_home}/.ssh/id_rsa":
      ensure  => file,
      owner   => $_tftp_sync_user,
      group   => $_tftp_sync_group,
      mode    => '0600',
      content => $::dc_tftp::ssh_private_key,
    } ->

    file { "${dc_tftp::tftp_sync_home}/.ssh/config" :
      ensure  => present,
      owner   => $_tftp_sync_user,
      group   => $_tftp_sync_group,
      mode    => '0600',
      content => template('dc_tftp/ssh_config.erb'),
    } ->

    lsyncd::process { 'tftp':
      content => template($::dc_tftp::conf_template),
      owner   => 'root',
      group   => 'root',
    }

  }

}
