# Class: dc_foreman_proxy::tftp
#
# Foreman_proxy tftp configuration
#
# Parameters:
#
# Actions:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_foreman_proxy::tftp inherits dc_foreman_proxy::install {

  include dc_tftp

  file { "${dc_tftp::tftp_dir}/boot":
    ensure  => directory,
    require => File[$dc_tftp::tftp_dir],
    owner   => $dc_tftp::tftp_user,
    group   => $dc_tftp::tftp_group,
    mode    => '2775',
  }

  file { "${dc_tftp::tftp_dir}/pxelinux.cfg":
    ensure  => directory,
    require => File[$dc_tftp::tftp_dir],
    owner   => $dc_tftp::tftp_user,
    group   => $dc_tftp::tftp_group,
    mode    => '2775',
  }

}
