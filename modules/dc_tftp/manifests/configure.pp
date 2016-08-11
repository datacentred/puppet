# == Class: dc_tftp::configure
#
# Configures the TFTP service
#
class dc_tftp::configure {

  assert_private()

  class { '::tftp':
    manage_dir => true,
    directory  => $dc_tftp::tftp_dir,
    inetd      => $dc_tftp::use_inetd,
    dir_owner  => $dc_tftp::tftp_user,
    dir_group  => $dc_tftp::tftp_group,
    dir_mode   => $dc_tftp::dir_mode,
  } ->

  file { "${dc_tftp::tftp_dir}/boot":
    ensure => directory,
    owner  => $dc_tftp::tftp_user,
    group  => $dc_tftp::tftp_group,
    mode   => $dc_tftp::dir_mode,
  } ->

  file { "${dc_tftp::tftp_dir}/pxelinux.cfg":
    ensure => directory,
    owner  => $dc_tftp::tftp_user,
    group  => $dc_tftp::tftp_group,
    mode   => $dc_tftp::dir_mode,
  }

}
