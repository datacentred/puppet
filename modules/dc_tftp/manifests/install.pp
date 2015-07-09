# Class: dc_tftp::install
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
class dc_tftp::install {

  include dc_tftp

  class { '::tftp':
    manage_dir => true,
    directory  => $dc_tftp::tftp_dir,
    inetd      => $dc_tftp::use_inetd,
    dir_owner  => $dc_tftp::tftp_user,
    dir_group  => $dc_tftp::tftp_group,
    dir_mode   => $dc_tftp::dir_mode
  }->
  file { "${dc_tftp::tftp_dir}/boot":
    ensure  => directory,
    require => File[$dc_tftp::tftp_dir],
    owner   => $dc_tftp::tftp_user,
    group   => $dc_tftp::tftp_group,
    mode    => $dc_tftp::dir_mode,
  }->
  file { "${dc_tftp::tftp_dir}/pxelinux.cfg":
    ensure  => directory,
    require => File[$dc_tftp::tftp_dir],
    owner   => $dc_tftp::tftp_user,
    group   => $dc_tftp::tftp_group,
    mode    => $dc_tftp::dir_mode,
  }

  if $dc_tftp::ha_sync {
    include dc_tftp::sync_user
  }

}
